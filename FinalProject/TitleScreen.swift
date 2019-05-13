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
    
    override func didMove(to view: SKView) {
        createBackground()
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

}


