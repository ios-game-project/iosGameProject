//
//  GameScene.swift
//  SpriteKitGame
//
//  Created by iMac03 on 2017-02-06.
//  Copyright © 2017 iMac03. All rights reserved.
//

import SpriteKit

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Monster   : UInt32 = 0b1       // 1
    static let Projectile: UInt32 = 0b10      // 2
}

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
        return CGFloat(sqrtf(Float(a)))
    }
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //add score label
    var scoreLabel:SKLabelNode!
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    // 1
    var monstersDestroyed = 0
    var fallFrequency = 1.5
    let player = SKSpriteNode(imageNamed: "player")
    
    override func didMove(to view: SKView) {
        // 2
        backgroundColor = SKColor.black
        // 3
        player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.1)
        // 4
        addChild(player)
        
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addMonster),
                SKAction.run(uploadFrequency),
                SKAction.wait(forDuration: fallFrequency)
                ])
        ))
        
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
        
        //add score label
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: 80, y: self.frame.size.height - 40)
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 24
        scoreLabel.fontColor = UIColor.white
        score = 0
        
        self.addChild(scoreLabel)
    }
    
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func uploadFrequency()  {
        if monstersDestroyed % 5 == 0 && self.fallFrequency > 1.0 {
            self.fallFrequency = self.fallFrequency - 1.0
            print(String(self.fallFrequency))
        }
    }
    
    func addMonster() {
        
        // Create sprite
        let monster = SKSpriteNode(imageNamed: "monster")
        let monster2 = SKSpriteNode(imageNamed: "monster2")
        
        let monster_array = [monster,monster2]
        
        
        // Determine where to spawn the monster along the X axis
        let  actualX = random(min: monster.size.width/2, max: size.width - monster.size.width/2)
        
        // Position the monster slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        //let temp = monster_array.count - 1
        let index = arc4random_uniform(UInt32(monster_array.count))
        let actual_monster = monster_array[Int(index)]
        
        actual_monster.physicsBody = SKPhysicsBody(rectangleOf: monster.size) // 1
        actual_monster.physicsBody?.isDynamic = true // 2
        actual_monster.physicsBody?.categoryBitMask = PhysicsCategory.Monster // 3
        actual_monster.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile // 4
        actual_monster.physicsBody?.collisionBitMask = PhysicsCategory.None // 5
        
        actual_monster.position = CGPoint(x: actualX, y: size.height + actual_monster.size.height/2)
        
        // Add the monster to the scene
        addChild(actual_monster)
        
        // Determine speed of the monster
        let actualDuration = CGFloat(5.0)
        
        // Create the actions
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -actual_monster.size.height/2), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        let loseAction = SKAction.run() {

            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, won: false, mark: self.monstersDestroyed)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
        actual_monster.run(SKAction.sequence([actionMove, loseAction, actionMoveDone]))
        
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // 1 - Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        
        // 2 - Set up initial location of projectile
        let projectile = SKSpriteNode(imageNamed: "projectile")
        projectile.position = player.position
        
        // 3 - Determine offset of location to projectile
        let offset = touchLocation - projectile.position
        
        // 4 - Bail out if you are shooting down or backwards
        //if (offset.x < -500) { return }
        
        // 5 - OK to add now - you've double checked position
        addChild(projectile)
        
        // 6 - Get the direction of where to shoot
        let direction = offset.normalized()
        
        // 7 - Make it shoot far enough to be guaranteed off screen
        let shootAmount = direction * 1000
        
        // 8 - Add the shoot amount to the current position
        let realDest = shootAmount + projectile.position
        
        // 9 - Create the actions
        let actionMove = SKAction.move(to: realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
        
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.None
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        
    }
    
    func projectileDidCollideWithMonster(projectile: SKSpriteNode, monster: SKSpriteNode) {
        print("Hit")
        
        //add explosion effect and sound
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = monster.position
        self.addChild(explosion)

        self.run(SKAction.playSoundFileNamed("ExplosionSound.mp3", waitForCompletion: false))
        
        projectile.removeFromParent()
        monster.removeFromParent()
        
        monstersDestroyed += 1
        score = monstersDestroyed
        
        self.run(SKAction.wait(forDuration:2)){
            explosion.removeFromParent()
        }

    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        // 1
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // 2
        if ((firstBody.categoryBitMask & PhysicsCategory.Monster != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Projectile != 0)) {
            if let monster = firstBody.node as? SKSpriteNode, let
                projectile = secondBody.node as? SKSpriteNode {
                projectileDidCollideWithMonster(projectile: projectile, monster: monster)
            }
        }
        
    }
}
