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
    var runnerVelocity = 0
    
    var counter = 0
    var timer = Timer()
    
    var rainDrops = [SKShapeNode()]
    
    var sceneController = SKView()
    
    let EnemyCategory   : UInt32 = 0x1 << 0
    let PlayerCategory : UInt32 = 0x1 << 1
    let CollisionCategory  : UInt32 = 0x1 << 2
    let ObjectiveCategory : UInt32 = 0x1 << 3
    let PowerUpCategory : UInt32 = 0x1 << 4
    
    override func didMove(to view: SKView) {
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        physicsWorld.contactDelegate = self
        
        beginMusic()
        createStoryboardObjects()
        rainDrop.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 5))
        runner.physicsBody?.applyImpulse(CGVector(dx: 5, dy: 0))
    }
    /*
     func test(){
     let scene = SKScene(fileNamed: "Title")
     
     // Now present the scene in a view.
     sceneController.presentScene(scene)//is being called, but no work
     print("aubfoubfsofabjfa")
     
     }*/
    
    func createStoryboardObjects() {
        createBackground()
        createGround()
        createDrop(position:  CGPoint(x:frame.midX,y:frame.maxY))
        createUmbrella()
        createRunner()
        startTimer()
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
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        counter += 1
        print(counter)
        if counter % 2 == 0 {
            changeRunnerMotion()
        }
        
        let random = CGFloat(Double.random(in: 0..<1))
        if(counter % 2 == 0){
            print(random)
            createDrop(position: CGPoint(x: frame.maxX * random, y: frame.maxY))
            
        }
        
        
    }
    
    func createDrop(position:CGPoint){
        var tempDrop = SKShapeNode(circleOfRadius: 10)
        tempDrop.position = position
        tempDrop.strokeColor = UIColor.black
        tempDrop.fillColor = UIColor.yellow
        tempDrop.name = "re"
        tempDrop.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        tempDrop.physicsBody?.isDynamic = true
        tempDrop.physicsBody?.usesPreciseCollisionDetection = true
        tempDrop.physicsBody?.friction = 0
        tempDrop.physicsBody?.affectedByGravity = false
        tempDrop.physicsBody?.restitution = 1
        tempDrop.physicsBody?.linearDamping = 0
        
        tempDrop.physicsBody!.contactTestBitMask = EnemyCategory
        
        addChild(tempDrop)
        //rainDrops.append(tempDrop)
        tempDrop.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 5))
    }
    
    func createUmbrella() {
        umbrella = SKSpriteNode(color: UIColor.white, size: CGSize(width: 100, height: 10))
        umbrella.position = CGPoint(x: frame.midX, y: frame.midY-60)
        umbrella.name = "umbrella"
        umbrella.physicsBody = SKPhysicsBody(rectangleOf: umbrella.size)
        umbrella.physicsBody?.isDynamic = false
        addChild(umbrella)
    }
    
    func beginMusic() {
        music = SKAudioNode(fileNamed: "rick.mp3")
        addChild(music)
    }
    
    func changeRunnerMotion() {
        let velocity = Int.random(in: -10 ... 10)
        runner.physicsBody?.velocity = (CGVector(dx: 0, dy: 0))
        runner.physicsBody?.applyImpulse(CGVector(dx: velocity, dy: 0))
    }
    
    func createRunner() {
        runner = SKShapeNode(rectOf: CGSize(width: 25, height: 25))
        runner.strokeColor = UIColor.black
        runner.fillColor = UIColor.orange
        runner.name = "runner"
        runner.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 25, height: 25))
        runner.position = CGPoint(x: frame.midX, y: frame.midY-130)
        runner.physicsBody?.isDynamic = true
        runner.physicsBody?.usesPreciseCollisionDetection = true
        runner.physicsBody?.friction = 0
        runner.physicsBody?.affectedByGravity = false
        runner.physicsBody?.restitution = 1
        runner.physicsBody?.linearDamping = 0
        addChild(runner)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch")
        //test()
        for touch in touches {
            if(playingGame){
                let location = touch.location(in: self)
                umbrella.position.x = location.x
            }
        }
        //let titleScreen = TitleScreen(fileNamed: "TitleScreen")
        //titleScreen?.scaleMode = .aspectFill
        //self.view?.presentScene(titleScreen!, transition: SKTransition.fade(withDuration: 0.5 ))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            umbrella.position.x = location.x
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("hello")
        
        if (contact.bodyA.node?.name == "ground" && contact.bodyB.node?.name == "re"){
            contact.bodyB.node?.removeFromParent()
            createDrop(position: CGPoint(x:(contact.bodyB.node?.position.x)!,y:frame.maxY))
            
        }else if(contact.bodyA.node?.name == "re" && contact.bodyB.node?.name == "ground") {
            contact.bodyA.node?.removeFromParent()
            createDrop(position: CGPoint(x:(contact.bodyA.node?.position.x)!,y:frame.maxY))
        }
        
        
        
        /*
        if (contact.bodyA.node?.name == "ground" && contact.bodyB.node?.name == "rainDrop"){
            //rainDrop.removeFromParent()
            createDrop(position:  CGPoint(x:frame.midX,y:frame.maxY))
        }else if(contact.bodyA.node?.name == "rainDrop" && contact.bodyB.node?.name == "ground") {
            //rainDrop.removeFromParent()
            createDrop(position: CGPoint(x:frame.midX,y:frame.maxY))
        }
        
        if (contact.bodyA.node?.name == "umbrella" && contact.bodyB.node?.name == "rainDrop") || (contact.bodyA.node?.name == "rainDrop" && contact.bodyB.node?.name == "umbrella") {
            //rainDrop.removeFromParent()
            print("rain drop removed - umbrella")
        }*/
    }
    
}
