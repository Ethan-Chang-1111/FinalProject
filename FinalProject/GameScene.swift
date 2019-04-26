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
    var music = SKAudioNode()
    
    var rainDrops = [SKSpriteNode()]
    
    var sceneController = SKView()
    
    
    let PlayerCategory   : UInt32 = 0x1 << 0
    let CollisionCategory : UInt32 = 0x1 << 1
    let EnemyCategory  : UInt32 = 0x1 << 2
    let ObjectiveCategory : UInt32 = 0x1 << 3
    let PowerUpCategory : UInt32 = 0x1 << 4
    
    
    override func didMove(to view: SKView) {
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        physicsWorld.contactDelegate = self
        
        beginMusic()
        
        createStoryboardObjects()
        rainDrop.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 5))
    }
    
    func test(){
        let scene = SKScene(fileNamed: "Title")
        
        // Now present the scene in a view.
        sceneController.presentScene(scene)//is being called, but no work
        print("aubfoubfsofabjfa")
        
    }
    
    func createStoryboardObjects() {
        createBackground()
        createGround()
        createDrop()
    }
    
    func createBackground() {
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = -1
        //addChild(background)
    }
    
    func createGround() {
        ground = SKSpriteNode(color: UIColor.green, size: CGSize(width: frame.height, height: 50))
        ground.position = CGPoint(x: frame.midX, y: frame.midY-175)
        ground.name = "ground"

        
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false
        
        ground.physicsBody!.contactTestBitMask = CollisionCategory
        
        addChild(ground)
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
        
        rainDrop.physicsBody!.contactTestBitMask = CollisionCategory
        
        addChild(rainDrop)
    }
    
    func beginMusic() {
        music = SKAudioNode(fileNamed: "rick.mp3")
        addChild(music)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("fbuiaiusfasfbas;fabs;")
        test()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.node?.name == "ground" && contact.bodyB.node?.name == "rainDrop") || (contact.bodyA.node?.name == "rainDrop" && contact.bodyB.node?.name == "ground") {
            rainDrop.removeFromParent()
            print("it worked")
        }
    }
    
}
