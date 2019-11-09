//
//  GameScene.swift
//  Exploding Monkeys
//
//  Created by Stefan Blos on 03.11.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

import SpriteKit
import GameplayKit

enum CollisionTypes: UInt32 {
    case banana = 1
    case building = 2
    case player = 4
}

class GameScene: SKScene {
    
    var player1: SKSpriteNode!
    var player2: SKSpriteNode!
    var banana: SKSpriteNode!
    
    var currentPlayer = 1
    
    var buildings = [BuildingNode]()
    
    weak var viewController: GameViewController!
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
        
        createBuildings()
    }
    
    func createBuildings() {
        var currentX: CGFloat = -15
        
        while currentX < 1024 {
            let size = CGSize(width: Int.random(in: 2...4) * 40, height: Int.random(in: 300...600))
            currentX += size.width + 2
            
            let building = BuildingNode(color: UIColor.red, size: size)
            building.position = CGPoint(x: currentX - (size.width / 2), y: size.height / 2)
            building.setup()
            addChild(building)
            
            buildings.append(building)
        }
    }
    
    func createPlayers() {
        player1 = createPlayerNode(named: "player1")
        
        let player1Building = buildings[1]
        player1.position = CGPoint(x: player1Building.position.x, y: player1Building.position.y + ((player1Building.size.height + player1.size.height) / 2))
        addChild(player1)
        
        player2 = createPlayerNode(named: "player2")
        
        let player2Building = buildings[1]
        player2.position = CGPoint(x: player2Building.position.x, y: player2Building.position.y + ((player2Building.size.height + player2.size.height) / 2))
        addChild(player2)
    }
    
    func createPlayerNode(named playerName: String) -> SKSpriteNode {
        let playerNode = SKSpriteNode(imageNamed: "player")
        playerNode.name = playerName
        playerNode.physicsBody = SKPhysicsBody(circleOfRadius: playerNode.size.width / 2)
        playerNode.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        playerNode.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
        playerNode.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        playerNode.physicsBody?.isDynamic = false
        
        return playerNode
    }
    
    func launch(angle: Int, velocity: Int) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
