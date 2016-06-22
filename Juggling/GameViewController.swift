//
//  GameViewController.swift
//  Juggling
//
//  Created by Aki Miyamoto on 6/19/16.
//  Copyright (c) 2016 Aki Miyamoto. All rights reserved.
//  http://www.akimiyamoto.com
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = GameScene()
        
        // Configure the view.
        let skView = self.view as! SKView
        #if DEBUG
            skView.showsDrawCount = true
            skView.showsFields = true
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.showsPhysics = true
            skView.showsQuadCount = true
        #endif
                
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
        scene.size = skView.frame.size
        skView.presentScene(scene)
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
