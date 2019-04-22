//
//  GameScene.swift
//  FinalProject
//
//  Created by Ethan Chang on 4/15/19.
//  Copyright © 2019 SomeAweApps. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var umbrella = SKSpriteNode()
    var runner = SKShapeNode()
    var rainDrop = SKShapeNode()
    var ground = SKSpriteNode()
    var playingGame = true
    var score = 0
    var background = SKSpriteNode(imageNamed: "defaultbackground")
    
    var rainDrops = [SKSpriteNode()]
    
    override func didMove(to view: SKView) {
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        physicsWorld.contactDelegate = self
        
        
        createStoryboardObjects()
        rainDrop.physicsBody?.applyImpulse(CGVector(dx: 5, dy: 0))
    }
    
    func createStoryboardObjects() {
        createBackground()
        createGround()
        createDrop()
    }
    
    func createBackground() {
        
        
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = -1
        addChild(background)
    }
    
    func createGround() {
        ground = SKSpriteNode(color: UIColor.green, size: CGSize(width: frame.height, height: 50))
        ground.position = CGPoint(x: frame.midX, y: -150)
        ground.name = "ground"
        
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false
        //addChild(ground)
    }
    
    func createDrop(){
        rainDrop = SKShapeNode(circleOfRadius: 10)
        rainDrop.position = CGPoint(x: frame.midX, y: frame.midY)
        rainDrop.strokeColor = UIColor.black
        rainDrop.fillColor = UIColor.yellow
        rainDrop.name = "rainDrop"
        rainDrop.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        rainDrop.physicsBody?.isDynamic = true
        rainDrop.physicsBody?.usesPreciseCollisionDetection = true
        rainDrop.physicsBody?.friction = 0
        rainDrop.physicsBody?.affectedByGravity = false
        rainDrop.physicsBody?.restitution = 1
        rainDrop.physicsBody?.linearDamping = 0
        addChild(rainDrop)
        
    }
    
}
