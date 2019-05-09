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
    var runner = SKSpriteNode()
    var rainDrop = SKShapeNode()
    var ground = SKSpriteNode()
    var playingGame = true
    var score = 0
    var background = SKSpriteNode(imageNamed: "defaultbackground")
    var music = SKAudioNode()
    var runnerVelocity = 0
    var umbrellaPowerup = SKShapeNode(circleOfRadius: 15)
    var powerupTimer = 0
    var powerupActive = false
    var bounceCounter = 0
    
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
        print("time elapsed: \(counter) seconds")
        if counter % 2 == 0 {
            changeRunnerMotion()
        }
        if counter % 15 == 0 {
            changeRunnerMotionExtreme()
            print("EXTREME RUNNER MOTION CHANGE ACTIVATED")
        }
        
        if counter % 5 == 0 {
            createPowerup()
        }
        
        let random = CGFloat(Double.random(in: -1..<1))
        if(counter % 2 == 0){
            createDrop(position: CGPoint(x: frame.maxX * random, y: frame.maxY))
            
        }
        
        if powerupActive == true {
            powerupTimer += 1
        }
        
        if powerupTimer == 10 {
            powerupTimer = 0
            removeAllPowerupBuffs()
        }
        
        if bounceCounter >= 5 {
            bounceCounter = 0
            umbrellaPowerup.removeFromParent()
        }
        
    }
    
    func createDrop(position:CGPoint){
        var tempDrop = SKShapeNode(circleOfRadius: 10)
        tempDrop.position = position
        tempDrop.strokeColor = UIColor.black
        tempDrop.fillColor = UIColor.yellow
        tempDrop.name = "drop"
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
    
    func createPowerup() {
        let powerupIdentity = 0
        if powerupIdentity == 0 {
            let randomPosition = CGFloat(Int.random(in: 0 ... 750))
            umbrellaPowerup.position = CGPoint(x: frame.maxX-randomPosition, y: frame.maxY)
            umbrellaPowerup.strokeColor = UIColor.green
            umbrellaPowerup.fillColor = UIColor.white
            umbrellaPowerup.name = "umbrellaPowerup"
            umbrellaPowerup.physicsBody = SKPhysicsBody(circleOfRadius: 15)
            umbrellaPowerup.physicsBody?.isDynamic = true
            umbrellaPowerup.physicsBody?.usesPreciseCollisionDetection = true
            umbrellaPowerup.physicsBody?.friction = 0
            umbrellaPowerup.physicsBody?.affectedByGravity = true
            umbrellaPowerup.physicsBody?.restitution = 0.60
            umbrellaPowerup.physicsBody?.linearDamping = 0
            umbrellaPowerup.physicsBody!.contactTestBitMask = PowerUpCategory
            addChild(umbrellaPowerup)
        }
    }
    
    
    func createUmbrella() {
        umbrella = SKSpriteNode(color: UIColor.white, size: CGSize(width: 120, height: 10))
        umbrella.position = CGPoint(x: frame.midX, y: frame.midY-60)
        umbrella.name = "umbrella"
        umbrella.physicsBody = SKPhysicsBody(rectangleOf: umbrella.size)
        umbrella.physicsBody?.isDynamic = false
        //umbrella.physicsBody?.contactTestBitMask = PowerUpCategory
        //umbrella.physicsBody?.contactTestBitMask = CollisionCategory
        addChild(umbrella)
    }
    
    func beginMusic() {
        music = SKAudioNode(fileNamed: "rick.mp3")
        addChild(music)
    }
    
    func changeRunnerMotion() {
        let velocity = Int.random(in: -20 ... 20)
        runner.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        runner.physicsBody?.applyImpulse(CGVector(dx: velocity, dy: 0))
    }
    
    func changeRunnerMotionExtreme() {
        let velocity = Int.random(in: -50 ... 50)
        runner.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        runner.physicsBody?.applyImpulse(CGVector(dx: velocity, dy: 0))
    }
    
    func removeAllPowerupBuffs() {
        powerupActive = false
        umbrella.size = CGSize(width: 120, height: 10)
    }
    
    func createRunner() {
        runner.texture = SKTexture(imageNamed: "marcos")
        runner.size = CGSize(width: 50, height: 50)
        runner.name = "runner"
        runner.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
        runner.position = CGPoint(x: frame.midX, y: frame.midY-110)
        runner.physicsBody?.isDynamic = true
        runner.physicsBody?.usesPreciseCollisionDetection = true
        runner.physicsBody?.friction = 0
        runner.physicsBody?.affectedByGravity = false
        runner.physicsBody?.restitution = 1
        runner.physicsBody?.linearDamping = 0
        runner.physicsBody?.allowsRotation = false
        let Yrange = SKRange(lowerLimit: frame.midY-110, upperLimit: frame.midY-110)
        let Xrange = SKRange(lowerLimit: frame.minX, upperLimit: frame.maxX)
        let lockToCenter = SKConstraint.positionX(Xrange, y: Yrange)
        runner.constraints = [ lockToCenter ]
        //runner.physicsBody?.contactTestBitMask = ObjectiveCategory
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
        
        if (contact.bodyA.node?.name == "ground" && contact.bodyB.node?.name == "drop"){
            createDrop(position: CGPoint(x:(contact.bodyB.node?.position.x)!,y:frame.maxY))
            contact.bodyB.node?.removeFromParent()
            
        }else if(contact.bodyA.node?.name == "drop" && contact.bodyB.node?.name == "ground") {
            createDrop(position: CGPoint(x:(contact.bodyA.node?.position.x)!,y:frame.maxY))
            contact.bodyA.node?.removeFromParent()
        }
        
        if (contact.bodyA.node?.name == "umbrella" && contact.bodyB.node?.name == "drop"){
            score += 1
            contact.bodyB.node?.removeFromParent()
        }else if(contact.bodyA.node?.name == "drop" && contact.bodyB.node?.name == "umbrella") {
            score += 1
            contact.bodyA.node?.removeFromParent()
        }
        
        if (contact.bodyA.node?.name == "runner" && contact.bodyB.node?.name == "drop"){
            score -= 1
            contact.bodyB.node?.removeFromParent()
        }else if(contact.bodyA.node?.name == "drop" && contact.bodyB.node?.name == "runner") {
            score -= 1
            contact.bodyA.node?.removeFromParent()
        }
        
        if (contact.bodyA.node?.name == "umbrellaPowerup" && contact.bodyB.node?.name == "umbrella"){
            contact.bodyA.node?.removeFromParent()
            umbrella.size = CGSize(width: 200, height: 10)
            powerupActive = true
            
        }else if(contact.bodyA.node?.name == "umbrella" && contact.bodyB.node?.name == "umbrellaPowerup") {
            contact.bodyB.node?.removeFromParent()
            umbrella.size = CGSize(width: 200, height: 10)
            powerupActive = true
        }
        
        if (contact.bodyA.node?.name == "umbrellaPowerup" && contact.bodyB.node?.name == "ground"){
            bounceCounter += 1
            print(bounceCounter)
        }else if(contact.bodyA.node?.name == "ground" && contact.bodyB.node?.name == "umbrellaPowerup") {
            bounceCounter += 1
            print(bounceCounter)
        }
        
    }
}
