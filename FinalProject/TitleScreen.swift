//
//  TitleScreen.swift
//  FinalProject
//
//  Created by Matthew Harkey on 4/26/19.
//  Copyright © 2019 SomeAweApps. All rights reserved.
//

import Foundation
import SpriteKit

class TitleScreen: SKScene {
    
    var startLabel = SKLabelNode()
    var timeCounter = 0.0
    var timer = Timer()
    var alphaSign = true
    
    override func didMove(to view: SKView) {
        createBackground()
        createLabel()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    func createLabel(){
        startLabel.position = CGPoint(x: -2.7,y: 0.0)
        startLabel = SKLabelNode(text: "Tap screen to start")
        startLabel.fontSize = 47
        startLabel.fontName = "HelveticaNeue-MediumItalic"
        addChild(startLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let gameScreen = GameScene(fileNamed: "GameScene")
        gameScreen?.scaleMode = .aspectFill
        self.view?.presentScene(gameScreen!, transition: SKTransition.fade(withDuration: 0.5 ))
        
    }
    func createBackground() {
        let rain = SKTexture(imageNamed: "betterBackground")
        for i in 0...1 {
            let rainBackground = SKSpriteNode(texture: rain)
            rainBackground.zPosition = -1
            rainBackground.position = CGPoint(x: 0, y: rainBackground.size.height * CGFloat(i))
            addChild(rainBackground)
            let moveDown = SKAction.moveBy(x: 0, y: -rainBackground.size.height, duration: 20)
            let moveReset = SKAction.moveBy(x: 0, y: rainBackground.size.height, duration: 0)
            let moveLoop = SKAction.sequence([moveDown, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            rainBackground.run(moveForever)
        }
    }
    
    @objc func updateTimer() {
        timeCounter += 0.01
        
        if startLabel.alpha >= 1.0 {
            alphaSign = false
        }
        if startLabel.alpha <= 0.0 {
            alphaSign = true
        }
        
        if alphaSign == true {
            startLabel.alpha += 0.1
        }
        if alphaSign == false {
            startLabel.alpha -= 0.1
        }
        
        
        
    }
    
}


