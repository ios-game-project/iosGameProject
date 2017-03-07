//
//  MenuScene.swift
//  SpriteKitGame
//
//  Created by yao on 2017-03-06.
//  Copyright © 2017 iMac03. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene, SKPhysicsContactDelegate{
    
    override func didMove(to view: SKView){
        
        physicsWorld.contactDelegate = self
        
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for touch in touches {
            let location = touch.location(in: self)
            
            let touchedNode = self.scene?.nodes(at: location)
            
            guard let nodes = touchedNode else {
                return
            }
            
            if nodes.first?.name == "playButton" {
                let scene = GameScene(size: (view?.bounds.size)!)
                let skView = self.view!
                skView.showsFPS = true
                skView.showsNodeCount = true
                skView.ignoresSiblingOrder = true
                scene.scaleMode = .resizeFill
                skView.presentScene(scene, transition: SKTransition.crossFade(withDuration: 1))
            }
            
            
        }
        
        
    }
    
    
    
    
}

