//
//  GameOverScene.swift
//  SpriteKitGame
//
//  Created by iMac03 on 2017-02-08.
//  Copyright © 2017 iMac03. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    
    var newGrade: Int = 0
    
    init(size: CGSize, won:Bool, mark:Int) {
        
        super.init(size: size)
        
        
        // 1
        backgroundColor = SKColor.white
        newGrade = mark
        let result = "Your Score: " + String (newGrade)
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = result
        label.fontSize = 30
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width/2, y: size.height*4.5/5)
        addChild(label)
        
        //label01~label05
        let label01 = SKLabelNode(fontNamed: "Chalkduster")
        //label01.text = result
        label01.fontSize = 15
        label01.fontColor = SKColor.black
        label01.position = CGPoint(x: size.width/2, y: size.height*3/5)
        addChild(label01)
        
        let label02 = SKLabelNode(fontNamed: "Chalkduster")
        //label01.text = result
        label02.fontSize = 15
        label02.fontColor = SKColor.black
        label02.position = CGPoint(x: size.width/2, y: size.height*2.5/5)
        addChild(label02)
        
        let label03 = SKLabelNode(fontNamed: "Chalkduster")
        //label01.text = result
        label03.fontSize = 15
        label03.fontColor = SKColor.black
        label03.position = CGPoint(x: size.width/2, y: size.height*2/5)
        addChild(label03)
        
        let label04 = SKLabelNode(fontNamed: "Chalkduster")
        //label01.text = result
        label04.fontSize = 15
        label04.fontColor = SKColor.black
        label04.position = CGPoint(x: size.width/2, y: size.height*1.5/5)
        addChild(label04)
        
        let label05 = SKLabelNode(fontNamed: "Chalkduster")
        //label01.text = result
        label05.fontSize = 15
        label05.fontColor = SKColor.black
        label05.position = CGPoint(x: size.width/2, y: size.height*1/5)
        addChild(label05)
        
        
        //test first launch
        let testLabel = SKLabelNode(fontNamed: "Chalkduster")
        testLabel.fontSize = 15
        testLabel.fontColor = SKColor.black
        testLabel.position = CGPoint(x: size.width/2, y: size.height*3.5/5)
        addChild(testLabel)

        
        if(!UserDefaults.standard.bool(forKey: "HasLaunchedOnce")){
            testLabel.text = "first launch"
            
            UserDefaults.standard.set(true, forKey: "HasLaunchedOnce")
            UserDefaults.standard.synchronize()
            
            //set new array to all 0s and save, initialize array
            var scoreArray = [0, 0, 0, 0, 0]
            
            //sort array with new score
            if(newGrade>scoreArray[4]){
                for i in (0..<5){
                    if(newGrade>scoreArray[i] && newGrade != scoreArray[0] && newGrade != scoreArray[1] && newGrade != scoreArray[2] && newGrade != scoreArray[3] && newGrade != scoreArray[4]){
                        //array[i] = newValue!
                        for j in (i+1..<5).reversed(){
                            scoreArray[j] = scoreArray[j-1]
                        }
                        scoreArray[i] = newGrade
                        break
                    }
                }
            }
            
            //save new array
            let defaults = UserDefaults.standard
            defaults.set(scoreArray, forKey: "SavedIntArray")
        
            //display all value
            label01.text = "\(scoreArray[0])"
            label02.text = "\(scoreArray[1])"
            label03.text = "\(scoreArray[2])"
            label04.text = "\(scoreArray[3])"
            label05.text = "\(scoreArray[4])"
            
        }else{
            testLabel.text = "launched before"
            
            //retrieve existed array and display
            let defaults = UserDefaults.standard
            var scoreArray = defaults.array(forKey: "SavedIntArray")  as? [Int] ?? [Int]()

            //sort array with new score
            if(newGrade>scoreArray[4]){
                for i in (0..<5){
                    if(newGrade>scoreArray[i] && newGrade != scoreArray[0] && newGrade != scoreArray[1] && newGrade != scoreArray[2] && newGrade != scoreArray[3] && newGrade != scoreArray[4]){
                        //array[i] = newValue!
                        for j in (i+1..<5).reversed(){
                            scoreArray[j] = scoreArray[j-1]
                        }
                        scoreArray[i] = newGrade
                        break
                    }
                }
            }

            //save new array
            defaults.set(scoreArray, forKey: "SavedIntArray")

            //display all value
            label01.text = "\(scoreArray[0])"
            label02.text = "\(scoreArray[1])"
            label03.text = "\(scoreArray[2])"
            label04.text = "\(scoreArray[3])"
            label05.text = "\(scoreArray[4])"

        }
        
        run(SKAction.sequence([
            SKAction.wait(forDuration: 6.0),
            SKAction.run() {
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let scene = GameScene(size: size)
                self.view?.presentScene(scene, transition:reveal)
            }
            ]))
    }
    
    // 6
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
