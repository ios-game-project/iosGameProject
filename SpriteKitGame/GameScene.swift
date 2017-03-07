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

    
    var lastPoint = CGPoint.zero
    var swiped = false
    
    var red:CGFloat = 1.0
    var green:CGFloat = 0.0
    var blue:CGFloat = 0.0
    
    var tool:UIImageView!
    var isDrawing = true
    
    //get screen size here
    let screenWidth  = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    var imageView:UIImageView!
    //imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
    
    var monsterArray = ["vline" : [SKSpriteNode](),"hline" : [SKSpriteNode]()]

    
    override func didMove(to view: SKView) {
        
       
        /*
         background.size = self.frame.size;
         background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
         addChild(background)
         */
        
        // 2
        backgroundColor = SKColor.blue
        //let color = SKColor(red: 100, green: 146, blue: 181, alpha: 0)
        //backgroundColor = color
        
        //create a UIImageView
        imageView = UIImageView(frame:CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth))
        self.view?.addSubview(imageView)
        
        
        tool = UIImageView()
        tool.frame = CGRect(x: (self.view?.bounds.size.width)!, y: (self.view?.bounds.size.height)!, width: 38, height: 38)
        
        self.view?.addSubview(tool)
        
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
        var monsterKey : String!
        
        // Determine where to spawn the monster along the X axis
        let  actualX = random(min: monster.size.width/2, max: size.width - monster.size.width/2)
        
        // Position the monster slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        //let temp = monster_array.count - 1
        let index = arc4random_uniform(UInt32(monster_array.count))
        
        if index == 0 {
            monsterKey = "vline"
        } else {
            monsterKey = "hline"
        }
        
        let actual_monster = monster_array[Int(index)]
        
        actual_monster.physicsBody = SKPhysicsBody(rectangleOf: monster.size) // 1
        actual_monster.physicsBody?.isDynamic = true // 2
        actual_monster.physicsBody?.categoryBitMask = PhysicsCategory.Monster // 3
        actual_monster.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile // 4
        actual_monster.physicsBody?.collisionBitMask = PhysicsCategory.None // 5
        actual_monster.name = monsterKey
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
        actual_monster.run(SKAction.sequence([actionMove, actionMoveDone]))
        
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        swiped = false
//        
//        if let touch = touches.first {
//            lastPoint = touch.location(in: self.view)
//        }
//    }
    
    func drawLines(fromPoint:CGPoint,toPoint:CGPoint) {
        UIGraphicsBeginImageContext((self.view?.frame.size)!)
        imageView.image?.draw(in: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        let context = UIGraphicsGetCurrentContext()
        
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        tool.center = toPoint
        
        context?.setBlendMode(CGBlendMode.normal)
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(5)
        context?.setStrokeColor(UIColor(red: red, green: green, blue: blue, alpha: 1.0).cgColor)
        
        context?.strokePath()
        
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //swiped = true
        
        if let touch = touches.first {
            let currentPoint = touch.location(in: self.view)
            drawLines(fromPoint: lastPoint, toPoint: currentPoint)
            
            lastPoint = currentPoint
        }
    }
    
    
    // shoot monsters
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        
//        if !swiped {
//            drawLines(fromPoint: lastPoint, toPoint: lastPoint)
//        }
//        self.imageView.image = nil
//        
//        
//        // 1 - Choose one of the touches to work with
//        guard let touch = touches.first else {
//            return
//        }
//        let touchLocation = touch.location(in: self)
//        
//        // 2 - Set up initial location of projectile
//        let projectile = SKSpriteNode(imageNamed: "projectile")
//        projectile.position = player.position
//        
//        // 3 - Determine offset of location to projectile
//        let offset = touchLocation - projectile.position
//        
//        // 4 - Bail out if you are shooting down or backwards
//        //if (offset.x < -500) { return }
//        
//        // 5 - OK to add now - you've double checked position
//        addChild(projectile)
//        
//        // 6 - Get the direction of where to shoot
//        let direction = offset.normalized()
//        
//        // 7 - Make it shoot far enough to be guaranteed off screen
//        let shootAmount = direction * 1000
//        
//        // 8 - Add the shoot amount to the current position
//        let realDest = shootAmount + projectile.position
//        
//        // 9 - Create the actions
//        let actionMove = SKAction.move(to: realDest, duration: 2.0)
//        let actionMoveDone = SKAction.removeFromParent()
//        projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
//        
//        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
//        projectile.physicsBody?.isDynamic = true
//        projectile.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
//        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
//        projectile.physicsBody?.collisionBitMask = PhysicsCategory.None
//        projectile.physicsBody?.usesPreciseCollisionDetection = true
//        
//    }
    
    
    
    
    // remove monster
    func projectileDidCollideWithMonster(name: String) {
        self.enumerateChildNodes(withName: name, using: {
            node, stop in
            // do something with node or stop
            node.removeFromParent()
            //add explosion effect and sound
            let explosion = SKEmitterNode(fileNamed: "Explosion")!
            explosion.position = node.position
            self.addChild(explosion)
            self.run(SKAction.playSoundFileNamed("ExplosionSound.mp3", waitForCompletion: false))
            self.monstersDestroyed += 1
            self.score = self.monstersDestroyed
            
            self.run(SKAction.wait(forDuration:2)){
                explosion.removeFromParent()
            }
        })
        

    }
    
    // run when collide
//    func didBegin(_ contact: SKPhysicsContact) {
//        
//        // 1
//        var firstBody: SKPhysicsBody
//        var secondBody: SKPhysicsBody
//        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
//            firstBody = contact.bodyA
//            secondBody = contact.bodyB
//        } else {
//            firstBody = contact.bodyB
//            secondBody = contact.bodyA
//        }
//        
//        // 2
//        if ((firstBody.categoryBitMask & PhysicsCategory.Monster != 0) &&
//            (secondBody.categoryBitMask & PhysicsCategory.Projectile != 0)) {
//            if let monster = firstBody.node as? SKSpriteNode, let
//                projectile = secondBody.node as? SKSpriteNode {
//                
//                //projectileDidCollideWithMonster(projectile: projectile, monster: monster, name: "vline")
//            }
//        }
//        
//    }
}
