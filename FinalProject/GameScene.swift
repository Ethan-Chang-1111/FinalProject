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
    var rainDrop = SKSpriteNode()
    var ground = SKSpriteNode()
    var playingGame = true
    var score = 0
    var background = SKSpriteNode(imageNamed: "cloudBacky")
    var music = SKAudioNode()
    var runnerVelocity = 0
    var umbrellaPowerup = SKSpriteNode(imageNamed: "umbrellaPowerupIcon")
    var sizePowerup = SKSpriteNode(imageNamed: "sizePowerupIcon")
    var powerupTimer = 0
    var powerupActive = false
    var bounceCounter = 0
    var restartLabel = SKLabelNode()
    
    var counter = 0
    var timer = Timer()
    
    var rainDrops = [SKSpriteNode()]
    var sceneController = SKView()
    
    let DropCategory   : UInt32 = 0x1 << 0
    let PlayerCategory : UInt32 = 0x1 << 1
    let GroundCategory  : UInt32 = 0x1 << 2
    let RunnerCategory : UInt32 = 0x1 << 3
    let PowerUpCategory : UInt32 = 0x1 << 4
    
    override func didMove(to view: SKView) {
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        physicsWorld.contactDelegate = self
        
        beginMusic()
        createStoryboardObjects()
        rainDrop.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 5))
        runner.physicsBody?.applyImpulse(CGVector(dx: 5, dy: 0))
    }

    
    
    func createStoryboardObjects() {
        createBackground()
        createGround()
        createDrop(position:  CGPoint(x:frame.midX,y:frame.maxY))
        createUmbrella()
        createRunner()
        startTimer()
        playingGame = true
    }
    
    func createBackground() {
        background.size = CGSize(width: frame.height, height: frame.width)
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = -1
        addChild(background)
    }
    
    func createGround() {
        ground = SKSpriteNode(imageNamed: "grass")
        ground.size = CGSize(width: frame.height, height: 50)
        ground.position = CGPoint(x: frame.midX, y: frame.midY-175)
        ground.name = "ground"
        
        
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false
        
        ground.physicsBody!.categoryBitMask = GroundCategory
        
        addChild(ground)
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if playingGame {
            counter += 1
            print("time elapsed: \(counter) seconds")
            if counter % 2 == 0 {
                changeRunnerMotion()
            }
            if counter % 15 == 0 {
                changeRunnerMotionExtreme()
                print("EXTREME RUNNER MOTION CHANGE ACTIVATED")
            }
            
            if (counter % 15 == 0){
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
            
            if bounceCounter >= 2 {
                bounceCounter = 0
                umbrellaPowerup.removeFromParent()
                sizePowerup.removeFromParent()
            }
        }
    }
    
    func createDrop(position:CGPoint){
        if playingGame {
            let tempDrop = SKSpriteNode()
            tempDrop.texture = SKTexture(imageNamed: "raindrop")
            tempDrop.size = CGSize(width: 15, height: 15)
            tempDrop.position = position
            tempDrop.name = "drop"
            tempDrop.physicsBody = SKPhysicsBody(circleOfRadius: 10)
            tempDrop.physicsBody?.isDynamic = true
            tempDrop.physicsBody?.usesPreciseCollisionDetection = true
            tempDrop.physicsBody?.friction = 0
            tempDrop.physicsBody?.affectedByGravity = false
            tempDrop.physicsBody?.restitution = 1
            tempDrop.physicsBody?.linearDamping = 0
            tempDrop.physicsBody?.allowsRotation = false
            let Yrange = SKRange(lowerLimit: frame.minY, upperLimit: frame.maxY+100)
            let Xrange = SKRange(lowerLimit: tempDrop.position.x, upperLimit: tempDrop.position.x)
            let lockToCenter = SKConstraint.positionX(Xrange, y: Yrange)
            tempDrop.constraints = [ lockToCenter ]
            
            tempDrop.physicsBody?.categoryBitMask = DropCategory
            
            tempDrop.physicsBody?.collisionBitMask = GroundCategory
            tempDrop.physicsBody?.contactTestBitMask = GroundCategory
            
            addChild(tempDrop)
            //rainDrops.append(tempDrop)
            tempDrop.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 5))
        }
    }
    
    func createPowerup() {
        if playingGame {
            let powerupIdentity = Int.random(in: 0 ... 1)
            if powerupIdentity == 0 {
                let randomPosition = CGFloat(Int.random(in: 0 ... 750))
                umbrellaPowerup.position = CGPoint(x: frame.maxX-randomPosition, y: frame.maxY)
                umbrellaPowerup.size = CGSize(width: 25, height: 25)
                umbrellaPowerup.name = "umbrellaPowerup"
                umbrellaPowerup.physicsBody = SKPhysicsBody(circleOfRadius: 25)
                umbrellaPowerup.physicsBody?.isDynamic = true
                umbrellaPowerup.physicsBody?.usesPreciseCollisionDetection = true
                umbrellaPowerup.physicsBody?.friction = 0
                umbrellaPowerup.physicsBody?.affectedByGravity = true
                umbrellaPowerup.physicsBody?.restitution = 0.60
                umbrellaPowerup.physicsBody?.linearDamping = 0
                umbrellaPowerup.physicsBody?.categoryBitMask = PowerUpCategory
                umbrellaPowerup.physicsBody?.collisionBitMask = GroundCategory
                umbrellaPowerup.physicsBody?.contactTestBitMask = GroundCategory
                addChild(umbrellaPowerup)
            }
            if powerupIdentity == 1 {
                let randomPosition = CGFloat(Int.random(in: 0 ... 750))
                sizePowerup.position = CGPoint(x: frame.maxX-randomPosition, y: frame.maxY)
                sizePowerup.size = CGSize(width: 25, height: 25)
                sizePowerup.name = "sizePowerup"
                sizePowerup.physicsBody = SKPhysicsBody(circleOfRadius: 25)
                sizePowerup.physicsBody?.isDynamic = true
                sizePowerup.physicsBody?.usesPreciseCollisionDetection = true
                sizePowerup.physicsBody?.friction = 0
                sizePowerup.physicsBody?.affectedByGravity = true
                sizePowerup.physicsBody?.restitution = 0.60
                sizePowerup.physicsBody?.linearDamping = 0
                sizePowerup.physicsBody!.categoryBitMask = PowerUpCategory
                sizePowerup.physicsBody!.collisionBitMask = GroundCategory
                sizePowerup.physicsBody?.contactTestBitMask = GroundCategory
                addChild(sizePowerup)
            }
        }
    }
    
    
    func createUmbrella() {
        umbrella.size = CGSize(width: 120, height: 25)
        umbrella.position = CGPoint(x: frame.midX, y: frame.midY-60)
        umbrella.name = "umbrella"
        umbrella.texture = SKTexture(imageNamed: "umbrellaTexture")
        umbrella.physicsBody = SKPhysicsBody(rectangleOf: umbrella.size)
        umbrella.physicsBody?.isDynamic = false
        umbrella.physicsBody?.allowsRotation = false
        let Yrange = SKRange(lowerLimit: frame.midY-60, upperLimit: frame.midY-60)
        let Xrange = SKRange(lowerLimit: frame.minX, upperLimit: frame.maxX)
        let lockToCenter = SKConstraint.positionX(Xrange, y: Yrange)
        umbrella.constraints = [ lockToCenter ]
        umbrella.physicsBody?.categoryBitMask = GroundCategory
        addChild(umbrella)
    }
    
    func beginMusic() {
        music = SKAudioNode(fileNamed: "rick.mp3")
        addChild(music)
    }
    
    func changeRunnerMotion() {
        let velocity = Int.random(in: -35 ... 35)
        runner.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        runner.physicsBody?.applyImpulse(CGVector(dx: velocity, dy: 0))
    }
    
    func changeRunnerMotionExtreme() {
        let velocity = Int.random(in: -60 ... 60)
        runner.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        runner.physicsBody?.applyImpulse(CGVector(dx: velocity, dy: 0))
    }
    
    func removeAllPowerupBuffs() {
        print("removeAllPowerupBuffs")
        powerupActive = false
        umbrella.size = CGSize(width: 120, height: 25)
        umbrella.texture = SKTexture(imageNamed: "umbrellaTexture")
        umbrella.physicsBody = SKPhysicsBody(rectangleOf: umbrella.size)
        umbrella.physicsBody?.allowsRotation = false
        let Yrange = SKRange(lowerLimit: frame.midY-60, upperLimit: frame.midY-60)
        let Xrange = SKRange(lowerLimit: frame.minX, upperLimit: frame.maxX)
        let lockToCenter = SKConstraint.positionX(Xrange, y: Yrange)
        umbrella.constraints = [ lockToCenter ]
        runner.size = CGSize(width: 50, height: 50)
        runner.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
        runner.physicsBody?.allowsRotation = false
    }
    
    func createRestartLabel() {
        restartLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        restartLabel.alpha = 0.70
        restartLabel.fontColor = SKColor.red
        restartLabel.text = "  Game Over!\nTap To Try Again"
        restartLabel.fontSize = 40
        restartLabel.numberOfLines = 0
        restartLabel.name = "restartLabel"
        addChild(restartLabel)
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
        runner.physicsBody?.categoryBitMask = RunnerCategory
        runner.physicsBody?.collisionBitMask = DropCategory
        runner.physicsBody?.contactTestBitMask = DropCategory
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
            if !playingGame{
                removeAllChildren()
                createStoryboardObjects()
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
            contact.bodyB.node?.removeFromParent()
            playingGame = false
            print("papa")
            removeAllChildren()
            timer.invalidate()
            counter = 0
            createRestartLabel()
        }else if(contact.bodyA.node?.name == "drop" && contact.bodyB.node?.name == "runner") {
            contact.bodyA.node?.removeFromParent()
            playingGame = false
            print("papa")
            removeAllChildren()
            timer.invalidate()
            counter = 0
            createRestartLabel()
        }
        
        
        
        if (contact.bodyA.node?.name == "umbrellaPowerup" && contact.bodyB.node?.name == "umbrella"){
            contact.bodyA.node?.removeFromParent()
            umbrella.size = CGSize(width: 200, height: 25)
            umbrella.texture = SKTexture(imageNamed: "longUmbrellaTexture")
            umbrella.physicsBody = SKPhysicsBody(rectangleOf: umbrella.size)
            umbrella.physicsBody?.allowsRotation = false
            powerupActive = true
            
        }else if(contact.bodyA.node?.name == "umbrella" && contact.bodyB.node?.name == "umbrellaPowerup") {
            contact.bodyB.node?.removeFromParent()
            umbrella.size = CGSize(width: 200, height: 25)
            umbrella.texture = SKTexture(imageNamed: "longUmbrellaTexture")
            umbrella.physicsBody = SKPhysicsBody(rectangleOf: umbrella.size)
            umbrella.physicsBody?.allowsRotation = false
            powerupActive = true
        }
        
        if (contact.bodyA.node?.name == "umbrellaPowerup" && contact.bodyB.node?.name == "ground"){
            bounceCounter += 1
            print(bounceCounter)
        }else if(contact.bodyA.node?.name == "ground" && contact.bodyB.node?.name == "umbrellaPowerup") {
            bounceCounter += 1
            print(bounceCounter)
        }
        
        
        
        
        if (contact.bodyA.node?.name == "sizePowerup" && contact.bodyB.node?.name == "umbrella"){
            contact.bodyA.node?.removeFromParent()
            runner.size = CGSize(width: 35, height: 35)
            runner.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 35, height: 35))
            runner.physicsBody?.allowsRotation = false
            powerupActive = true
            
        }else if(contact.bodyA.node?.name == "umbrella" && contact.bodyB.node?.name == "sizePowerup") {
            contact.bodyB.node?.removeFromParent()
            runner.size = CGSize(width: 35, height: 35)
            runner.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 35, height: 35))
            runner.physicsBody?.allowsRotation = false
            powerupActive = true
        }
        
        if (contact.bodyA.node?.name == "sizePowerup" && contact.bodyB.node?.name == "ground"){
            bounceCounter += 1
            print(bounceCounter)
        }else if(contact.bodyA.node?.name == "ground" && contact.bodyB.node?.name == "sizePowerup") {
            bounceCounter += 1
            print(bounceCounter)
        }
        
    }
}
