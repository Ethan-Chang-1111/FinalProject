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
    var rainDrop = SKSpriteNode()
    var ground = SKSpriteNode()
    var playingGame = true
    var score = 0
    var background = SKSpriteNode(imageNamed: "defaultbackground")
    
    var rainDrops = [SKSpriteNode()]
    
    override func didMove(to view: SKView) {
        createStoryboardObjects()
    }
    
    func createStoryboardObjects() {
        createBackground()
        createGround()
    }
    
    func createBackground() {
        background.position = CGPoint(x: 0, y: 0)
        addChild(background)
    }
    
    func createGround() {
        ground = SKSpriteNode(color: UIColor.green, size: CGSize(width: 50, height: frame.height))
        ground.position = CGPoint(x: frame.maxX, y: frame.midY)
        ground.name = "ground"
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false
        addChild(ground)
    }
    
}

//DID NOT COMMIT
