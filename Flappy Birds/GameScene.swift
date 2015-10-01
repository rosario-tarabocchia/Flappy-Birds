//
//  GameScene.swift
//  Flappy Birds
//
//  Created by Rosario Tarabocchia on 10/1/15.
//  Copyright (c) 2015 RLDT. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var bird = SKSpriteNode()
    var bg = SKSpriteNode()
    var pipe1 = SKSpriteNode()
    var pipe2 = SKSpriteNode()
    
    var gameOverLabel = SKLabelNode()
    
    enum colliderType : UInt32 {
        
        case bird = 1
        case object = 2
        case gap = 4
        
    }
    
    var gameOver = false
    
    var score = 0
    
    var scoreLabel = SKLabelNode()
    
    var movingObjects = SKSpriteNode()
    
    var labelContainer = SKSpriteNode()
    
    func makeBG(){
        
        let bgTexture = SKTexture(imageNamed: "bg.png")
        
        let moveBG = SKAction.moveByX(-bgTexture.size().width, y: 0, duration: 9)
        
        let replaceBG = SKAction.moveByX(bgTexture.size().width, y: 0, duration: 0)
        
        let moveBGForever = SKAction.repeatActionForever(SKAction.sequence([moveBG, replaceBG]))
        
        
        for var i : CGFloat = 0; i < 3; i++ {
            
            bg = SKSpriteNode(texture: bgTexture)
            
            bg.position = CGPoint(x: bgTexture.size().width/2 + bgTexture.size().width * i , y: CGRectGetMidY(self.frame))
            
            bg.zPosition = -5
            
            bg.size.height = self.frame.height
            
            bg.runAction(moveBGForever)
            
            movingObjects.addChild(bg)
            
        }

        
        
        
    }
    
    override func didMoveToView(view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        self.addChild(movingObjects)
        
        makeBG()
        
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - 75)
        
        self.addChild(scoreLabel)
        self.addChild(labelContainer)
        
        
        
        let birdTexture = SKTexture(imageNamed: "flappy1.png")
        
        let birdTexture2 = SKTexture(imageNamed: "flappy2.png")
        
        let birdTexture3 = SKTexture(imageNamed: "flappy3.png")
        
        let birdAnimation = SKAction.animateWithTextures([birdTexture, birdTexture2, birdTexture3], timePerFrame: 0.2)
        
        let makeBirdFlap = SKAction.repeatActionForever(birdAnimation)
        
        bird = SKSpriteNode(texture: birdTexture)
        
        bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))

        bird.runAction(makeBirdFlap)
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().height/3)
        bird.physicsBody!.dynamic = true
        bird.physicsBody!.allowsRotation = false
        
        bird.physicsBody!.categoryBitMask = colliderType.bird.rawValue
        bird.physicsBody!.contactTestBitMask = colliderType.object.rawValue
        bird.physicsBody!.collisionBitMask = colliderType.object.rawValue
        
        self.addChild(bird)
        
        
        var ground = SKNode()
        ground.position = CGPointMake(0, 0)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 1))
        ground.physicsBody!.dynamic = false
        
        ground.physicsBody!.categoryBitMask = colliderType.object.rawValue
        ground.physicsBody!.contactTestBitMask = colliderType.object.rawValue
        ground.physicsBody!.collisionBitMask = colliderType.object.rawValue
        
        self.addChild(ground)
        
        

        
        _ = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("makePipes"), userInfo: nil, repeats: true)
        

        
       
        
        
        

    }
    
    
    func makePipes(){
        
        let gapHeight = bird.size.height * 3
        
        let movementAmount = arc4random() % UInt32(self.frame.size.height / 2)
        
        let pipeOffset = CGFloat(movementAmount) - self.frame.size.height / 4
        
        let movePipes = SKAction.moveByX(-self.frame.size.width * 2, y: 0, duration: NSTimeInterval(self.frame.size.width / 100))
        
        let removePipes = SKAction.removeFromParent()
        
        let moveAndRemovePipes = SKAction.sequence([movePipes, removePipes])
        
        
        var pipe1Texture = SKTexture(imageNamed: "pipe1.png")
        var pipe1 = SKSpriteNode(texture: pipe1Texture)
        pipe1.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) + pipe1Texture.size().height/2 + gapHeight/2 + pipeOffset)
        
        pipe1.zPosition = -3
        
        pipe1.runAction(moveAndRemovePipes)
        
        pipe1.physicsBody = SKPhysicsBody(rectangleOfSize: pipe1Texture.size())
        pipe1.physicsBody!.dynamic = false
        
        pipe1.physicsBody!.categoryBitMask = colliderType.object.rawValue
        pipe1.physicsBody!.contactTestBitMask = colliderType.object.rawValue
        pipe1.physicsBody!.collisionBitMask = colliderType.object.rawValue
        
        movingObjects.addChild(pipe1)
        
        
        var pipe2Texture = SKTexture(imageNamed: "pipe2.png")
        var pipe2 = SKSpriteNode(texture: pipe2Texture)
        pipe2.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) - pipe2Texture.size().height/2 - gapHeight/2 + pipeOffset)
        
        pipe2.zPosition = -4
        
        pipe2.runAction(moveAndRemovePipes)
        
        pipe2.physicsBody = SKPhysicsBody(rectangleOfSize: pipe2Texture.size())
        pipe2.physicsBody!.dynamic = false
        
        pipe2.physicsBody!.categoryBitMask = colliderType.object.rawValue
        pipe2.physicsBody!.contactTestBitMask = colliderType.object.rawValue
        pipe2.physicsBody!.collisionBitMask = colliderType.object.rawValue
        
        movingObjects.addChild(pipe2)
        
        
        var gap = SKNode()
        gap.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) + pipeOffset)
        
        gap.runAction(moveAndRemovePipes)
        gap.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(pipe1.size.width / 2, gapHeight))
        gap.physicsBody?.dynamic = false
        
        gap.physicsBody!.categoryBitMask = colliderType.gap.rawValue
        gap.physicsBody!.contactTestBitMask = colliderType.bird.rawValue
        gap.physicsBody!.collisionBitMask = colliderType.gap.rawValue
        
        movingObjects.addChild(gap)
        
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == colliderType.gap.rawValue || contact.bodyB.categoryBitMask == colliderType.gap.rawValue {
            
            score++
            
            scoreLabel.text = "\(score)"
            
        } else {
            
            if gameOver == false {
        
                gameOver = true
        
                self.speed = 0
            
                gameOverLabel.fontName = "Helvetica"
                gameOverLabel.fontSize = 25
                gameOverLabel.text = "GAME OVER! Tap to play again."
                gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
                
                
            
            
                labelContainer.addChild(gameOverLabel)
                
            }
            
        
            
        }
    }
    
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if gameOver == false {
        
            bird.physicsBody?.velocity = CGVectorMake(0, 0)
            bird.physicsBody?.applyImpulse(CGVectorMake(0, 50))
            
            }
        
        else {
            
            score = 0
            
            scoreLabel.text = "0"
            
            bird.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
            
            bird.physicsBody!.velocity = CGVectorMake(0, 0)
            
            movingObjects.removeAllChildren()
            
            makeBG()
            
            self.speed = 1
            
            gameOver = false
            
            labelContainer.removeAllChildren()
            
            
            
        }
        

    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }


















}
