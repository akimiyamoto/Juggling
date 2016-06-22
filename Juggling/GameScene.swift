//
//  GameScene.swift
//  Juggling
//
//  Created by Aki Miyamoto on 6/19/16.
//  Copyright (c) 2016 Aki Miyamoto. All rights reserved.
//  http://www.akimiyamoto.com
//

import SpriteKit
import CoreMotion

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    var motionManager: CMMotionManager!
    var accelerometerHandler: CMAccelerometerHandler?
    
    var floorSprite:SKSpriteNode!
    var ball:SKSpriteNode?
    var gonode:SKSpriteNode?
    var CurrentScoreLabel:SKLabelNode!
    var HighScoreLabel:SKLabelNode!
    
    var HighScore:Int = 0
    var CurrentScore:Int = 0
    var PlayingFlag:Bool = false
    let HighScoreStorageKey = "HIGHSCORE"
    let GameSpeed:CGFloat = 1.6
    let defaults = NSUserDefaults.standardUserDefaults()
    let jumpAmount:Double = 310.0
    
    var Ballx1:CGFloat = 0.0
    var Ballx2:CGFloat = 0.0
    var Ballx3:CGFloat = 0.0
    var Ballx4:CGFloat = 0.0
    let se_ball = SKAction.playSoundFileNamed("soccerball.mp3", waitForCompletion: false)
    
    override func didMoveToView(view: SKView) {
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        self.physicsWorld.speed = self.GameSpeed
        self.physicsWorld.contactDelegate = self
        CreateWall()
        CreateBackground()
        CreateScoreLabel()
        
        motionManager = CMMotionManager()
        motionManager.accelerometerUpdateInterval = 0.1
        self.accelerometerHandler = {(data:CMAccelerometerData?, error:NSError?) -> Void
            in
            let x = data!.acceleration.x * 10
            self.physicsWorld.gravity = CGVector(dx: x, dy: -9.8)
        }
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler: accelerometerHandler!)
        CreateBall()
    }
    
    
    func CreateWall(){
        
        let floorSprite = SKSpriteNode()
        floorSprite.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 5))
        floorSprite.physicsBody?.dynamic = false
        floorSprite.physicsBody?.restitution = 0.4
        floorSprite.position = CGPoint(x: self.frame.size.width / 2.0 , y: -5)
        floorSprite.physicsBody?.contactTestBitMask = 0x1 << 1
        floorSprite.physicsBody?.collisionBitMask = 0x1 << 1
        floorSprite.zPosition = 4
        self.addChild(floorSprite)
        self.floorSprite = floorSprite
        
        let topwall = SKSpriteNode()
        topwall.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 5))
        topwall.physicsBody?.collisionBitMask = 0x1 << 1
        topwall.physicsBody?.dynamic = false
        topwall.physicsBody?.restitution = 0.6
        topwall.position = CGPoint(x: self.frame.size.width / 2.0 , y: self.frame.size.height)
        topwall.zPosition = 4
        self.addChild(topwall)
        
        let leftwall = SKSpriteNode()
        leftwall.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(5, self.frame.size.height))
        leftwall.physicsBody?.collisionBitMask = 0x1 << 1
        leftwall.physicsBody?.dynamic = false
        leftwall.position = CGPoint(x: 0 , y: self.frame.size.height / 2.0)
        leftwall.zPosition = 4
        leftwall.physicsBody?.restitution = 1.0
        self.addChild(leftwall)
        
        let rightwall = SKSpriteNode()
        rightwall.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(5, self.frame.size.height))
        rightwall.physicsBody?.collisionBitMask = 0x1 << 1
        rightwall.physicsBody?.dynamic = false
        rightwall.physicsBody?.restitution = 1.0
        rightwall.position = CGPoint(x: self.frame.size.width , y: self.frame.size.height / 2.0)
        rightwall.zPosition = 4
        self.addChild(rightwall)
    }
    
    func CreateBackground(){
        
        let bg = SKTexture(imageNamed: "field")
        bg.filteringMode = .Linear
        let bgnode = SKSpriteNode(texture: bg, size: bg.size())
        let w = abs(bg.size().width - self.frame.size.width) / 2.0
        bgnode.position = CGPoint(x: (bg.size().width - w) / 2.0, y: bg.size().height / 2.0)
        self.addChild(bgnode)
    }
    
    func CreateScoreLabel(){
        
        self.CurrentScoreLabel = SKLabelNode(fontNamed: "Helvetica")
        self.CurrentScoreLabel.text = "0"
        self.CurrentScoreLabel.fontSize = 48
        self.CurrentScoreLabel.position =  CGPoint(x: self.frame.size.width / 2.0, y: self.frame.size.height*0.80)
        self.CurrentScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        self.CurrentScoreLabel.fontColor = UIColor.whiteColor()
        self.addChild(self.CurrentScoreLabel)
        
        self.HighScore = self.defaults.integerForKey(self.HighScoreStorageKey)
        self.HighScoreLabel = SKLabelNode(fontNamed: "Helvetica")
        self.HighScoreLabel.position = CGPoint(x: self.frame.size.width * 0.5, y: self.frame.size.height - 50)
        self.HighScoreLabel.text = "0"
        self.HighScoreLabel.fontSize = 32
        self.HighScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        self.HighScoreLabel.fontColor = UIColor.whiteColor()
        self.HighScoreLabel.text = "\(HighScore)"
        self.addChild(self.HighScoreLabel)
        
        let HighScoreLabelLabel = SKLabelNode(fontNamed: "Helvetica")
        HighScoreLabelLabel.position = CGPoint(x: self.frame.size.width * 0.5, y: self.frame.size.height - 20)
        HighScoreLabelLabel.text = "HIGH SCORE"
        HighScoreLabelLabel.fontSize = 12
        HighScoreLabelLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        HighScoreLabelLabel.fontColor = UIColor.whiteColor()
        self.addChild(HighScoreLabelLabel)
    }
    
    func CreateBall(){
        
        let ballTexture = SKTexture(imageNamed: "ball")
        self.ball = SKSpriteNode(texture: ballTexture)
        self.ball!.physicsBody = SKPhysicsBody(texture: ballTexture, size: ball!.size)
        
        self.ball!.physicsBody?.dynamic = true
        self.ball!.physicsBody?.restitution = 0.6
        self.ball!.physicsBody?.mass = 0.430 // m = 430g
        self.ball!.position = CGPoint(x: self.frame.size.width / 2 , y: self.frame.size.height)
        self.ball!.physicsBody?.collisionBitMask = 0x1 << 1
        self.ball!.physicsBody?.allowsRotation = true
        self.ball!.zPosition = 10
        self.addChild(self.ball!)
        
        let Ballx0 = ball!.size.width
        self.Ballx1 = Ballx0 * 0.2
        self.Ballx2 = Ballx0 * 0.4
        self.Ballx3 = Ballx0 * 0.6
        self.Ballx4 = Ballx0 * 0.8
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let ballHeight = self.ball!.size.height
        for touch : UITouch in touches{
            
            let tpoint = touch.locationInNode(self)
            var xpower:Double = 0.0
            
            if tpoint.y < (self.ball!.position.y + (ballHeight / 2.0)) {
                if tpoint.y > (self.ball!.position.y - (ballHeight / 2.0))
                {
                    let xpo = abs(tpoint.x - self.ball!.position.x)
                    if(xpo < self.Ballx1){
                        xpower = 10
                    }else if (xpo < self.Ballx2) {
                        xpower = 100
                    }else if (xpo < self.Ballx3) {
                        xpower = 150
                    }else if (xpo < self.Ballx4) {
                        xpower = 200
                    }else{
                        return
                    }
                    
                    if xpo > 0 {
                        xpower = xpower * -1
                    }
                    self.ball!.physicsBody?.velocity = CGVector.zero
                    self.ball!.physicsBody?.applyImpulse(CGVector(dx: xpower, dy: self.jumpAmount))
                    self.ball!.runAction(se_ball)

                    if !self.PlayingFlag { // initial touch
                        self.CurrentScore = 1
                        self.gonode?.removeFromParent()
                        self.PlayingFlag = true
                    }else{
                        self.CurrentScore = self.CurrentScore + 1
                    }
                    self.CurrentScoreLabel.text = "\(self.CurrentScore)"
                }
            }
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        if !self.PlayingFlag { return }
        if contact.bodyA.node == self.floorSprite || contact.bodyB.node == self.floorSprite {
            
            self.PlayingFlag = false
            let sprite = SKSpriteNode  (imageNamed: "gameover")
            sprite.position = CGPoint(x: self.size.width / 2.0, y: self.size.height / 2.0)
            self.addChild(sprite)
            self.gonode = sprite
            self.ball?.removeFromParent()
            
            if(CurrentScore > HighScore){
                defaults.setObject(CurrentScore, forKey: self.HighScoreStorageKey)
                defaults.synchronize()
                self.HighScoreLabel.text = "\(self.defaults.integerForKey(self.HighScoreStorageKey))"
            }
            CreateBall()
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if (self.PlayingFlag){
            self.floorSprite.position = CGPoint(x: self.frame.size.width / 2.0 , y: -(self.ball!.size.height + 15))
        }else{
            self.floorSprite.position = CGPoint(x: self.frame.size.width / 2.0 , y: -5)
        }
    }
}
