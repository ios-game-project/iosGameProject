//
//  GameViewController.swift
//  SpriteKitGame
//
//  Created by iMac03 on 2017-02-06.
//  Copyright © 2017 iMac03. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    
    @IBOutlet weak var drawer: DrawingView!
    var recognizer: GestureRecognizer!
    var scene: GameScene!
    // draws the user input
    //@IBOutlet weak var circlerDrawer: CircleDrawView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "back")!)
        
        
        //show gamescene first
        scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene?.scaleMode = .fill
        skView.presentScene(scene)
 
        /*
        //show menescene first
        let scene = MenuScene(fileNamed: "MenuScene")
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene?.scaleMode = .fill
        skView.presentScene(scene)
        */
        
        
        recognizer = GestureRecognizer(target: self, action: #selector(GameViewController.circled))
        view.addGestureRecognizer(recognizer)
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func circled(c: GestureRecognizer){
        if c.state == .began {
            //print("began")            
        }
        if c.state == .changed {
            drawer.updatePath(p: c.path)
        }
        if c.state == .failed {
            print("failed")
        }
        if c.state == .ended {
            drawer.clear()
            print("vertical line")            
            scene.projectileDidCollideWithMonster(name: "vline")
        }
        if c.state == .possible{
            print("possible")
        }
        /*
         if c.state == .ended || c.state == .failed || c.state == .cancelled {
         circlerDrawer.updateFit(fit: c.fitResult, madeCircle: c.isCircle)
         }*/
    }

    
}
