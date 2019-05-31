//
//  GameScene.swift
//  Shooting Gallery
//
//  Created by Stefan Blos on 25.05.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var gameTimer: Timer?
    var timerInterval: Double = 2
    var timerReductionFactor = 0.1

    var objectsCreated = 0
    var speedChangeInterval = 20
    var isGameRunning = false
    
    var scoreLabel: SKLabelNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        setupLayout()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isGameRunning {
            startGame()
            return
        }
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            if node.name != "target" { continue }
            node.removeFromParent()
            score += 1
            
            // TODO play sound
        }
    }
    
    func setupLayout() {
        let woodenPlank = SKSpriteNode(imageNamed: "wooden_plank")
        woodenPlank.size = CGSize(width: 870, height: 70)
        woodenPlank.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        woodenPlank.zPosition = -1
        addChild(woodenPlank)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
    }
    
    func startGame() {
        score = 0
        objectsCreated = 0
        
        removeEnemies(all: true)
        
        gameTimer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        
        isGameRunning = true
    }
    
    @objc func createEnemy() {
        let target = SKSpriteNode(imageNamed: "target0")
        target.position = CGPoint(x: 0, y: (self.frame.height / 2) + 100)
        target.name = "target"
        addChild(target)
        
        target.physicsBody = SKPhysicsBody(texture: target.texture!, size: target.size)
        target.physicsBody?.velocity = CGVector(dx: 120, dy: 0)
        target.physicsBody?.linearDamping = 0
        
        //target.addPhysicsBody()
        
        objectsCreated += 1
        
        if objectsCreated % speedChangeInterval == 0 {
            if timerInterval <= 0.5 { return }
            
            gameTimer?.invalidate()
            
            timerInterval -= timerReductionFactor
            gameTimer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        removeEnemies()
    }
    
    func removeEnemies(all: Bool = false) {
        for node in children {
            if node.name == "target" {
                print(node.position.x)
                if node.position.x >= 1100 || all {
                    node.removeFromParent()
                    score -= 1
                }
            }
        }
    }
}
