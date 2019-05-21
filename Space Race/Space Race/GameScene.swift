//
//  GameScene.swift
//  Space Race
//
//  Created by Stefan Blos on 19.05.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starField: SKEmitterNode!
    var player: SKSpriteNode!
    var gameOverLabel: SKLabelNode?
    var messageLabel: SKLabelNode?
    var touchToStartLabel: SKLabelNode?
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    let possibleEnemies = ["ball", "hammer", "tv"]
    var isGameOver = false
    var gameTimer: Timer?
    var timerInterval: Double = 1
    var enemiesCreated = 0
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        starField = SKEmitterNode(fileNamed: "starfield")!
        starField.position = CGPoint(x: 1024, y: 384)
        starField.advanceSimulationTime(10)
        addChild(starField)
        starField.zPosition = -1
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        startGame()
    }
    
    func prepareGame() {
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)
        
        gameOverLabel?.removeFromParent()
        messageLabel?.removeFromParent()
        touchToStartLabel?.removeFromParent()
        
        for child in children {
            if child.name == "enemy" || child.name == "explosion" {
                child.removeFromParent()
            }
        }
    }
    
    func startGame() {
        score = 0
        
        prepareGame()
        
        gameTimer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }
    
    func gameOver(with text: String) {
        isGameOver = true
        player.removeFromParent()
        
        showGameOverMessages(saying: text)
        gameTimer?.invalidate()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameOver {
            isGameOver = false
            startGame()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isGameOver {
            gameOver(with: "You are not allowed to lift your finger!")
        }
    }
    
    func showGameOverMessages(saying mes: String) {
        gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        messageLabel = SKLabelNode(fontNamed: "Chalkduster")
        touchToStartLabel = SKLabelNode(fontNamed: "Chalkduster")
        
        guard let gameOverLabel = gameOverLabel, let messageLabel = messageLabel, let touchToStartLabel = touchToStartLabel else { return }
        
        gameOverLabel.text = "Game Over!"
        gameOverLabel.position = CGPoint(x: 512, y: 414)
        gameOverLabel.horizontalAlignmentMode = .center
        addChild(gameOverLabel)
        
        messageLabel.text = mes
        messageLabel.position = CGPoint(x: 512, y: 364)
        messageLabel.horizontalAlignmentMode = .center
        addChild(messageLabel)
    
        touchToStartLabel.text = "Touch screen to start game"
        touchToStartLabel.position = CGPoint(x: 512, y: 314)
        touchToStartLabel.horizontalAlignmentMode = .center
        addChild(touchToStartLabel)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)
        
        if location.y < 100 {
            location.y = 100
        } else if location.y > 668 {
            location.y = 668
        }
        
        player.position = location
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        explosion.name = "explosion"
        addChild(explosion)
        
        gameOver(with: "You collided with an object!")
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        
        if !isGameOver {
            score += 1
        }
    }
    
    @objc func createEnemy() {
        guard let enemy = possibleEnemies.randomElement() else { return }
        
        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
        sprite.name = "enemy"
        addChild(sprite)
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
        
        enemiesCreated += 1
        
        if enemiesCreated % 20 == 0 {
            if timerInterval <= 0.1 { return }
            
            gameTimer?.invalidate()
            
            timerInterval -= 0.1
            print("Game just got faster with interval \(timerInterval)")
            gameTimer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        }
    }
}
