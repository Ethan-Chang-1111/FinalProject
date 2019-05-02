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
        self.backgroundColor = SKColor.green
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let gameScreen = GameScene(fileNamed: "GameScene")
        gameScreen?.scaleMode = .aspectFill
        self.view?.presentScene(gameScreen!, transition: SKTransition.fade(withDuration: 0.5 ))
    }
}
