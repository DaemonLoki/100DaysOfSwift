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
    var timerInterval: Double = 1.5
    var timerReductionFactor = 0.2

    var objectsCreated = 0
    var changeInterval = 15
    let baseVelocity: CGFloat = 100
    var isGameRunning = false
    
    var scoreLabel: SKLabelNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    let plankWidth: Int = 870
    let plankHeight: Int = 50
    let plankOffset: CGFloat = 50
    
    let plankYPositions: [CGFloat] = [
        0.25,
        0.5,
        0.75
    ]
    
    let targets = [
        "target0",
        "target1",
        "target2",
        "target3"
    ]
    
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
        for plankYPos in plankYPositions {
            setupWoodenPlank(yPos: self.frame.height * plankYPos)
        }
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
    }
    
    func setupWoodenPlank(yPos: CGFloat) {
        let woodenPlank = SKSpriteNode(imageNamed: "wooden_plank")
        woodenPlank.size = CGSize(width: plankWidth, height: plankHeight)
        woodenPlank.position = CGPoint(x: self.frame.width / 2, y: yPos - plankOffset)
        woodenPlank.zPosition = -1
        addChild(woodenPlank)
    }
    
    func startGame() {
        score = 0
        objectsCreated = 0
        
        removeEnemies(all: true)
        
        gameTimer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        
        isGameRunning = true
    }
    
    @objc func createEnemy() {
        let target = SKSpriteNode(imageNamed: targets[Int.random(in: 0...3)])
        let randomInt = Int.random(in: 0...2)
        let yPos = self.frame.height * plankYPositions[randomInt] - plankOffset
        let velocity: CGFloat
        let xPos: CGFloat
        if randomInt % 2 == 0 {
            velocity = baseVelocity * (1 / CGFloat(timerInterval))
            xPos = 0
        } else {
            velocity = -baseVelocity * (1 / CGFloat(timerInterval))
            xPos = 1024
        }
        target.position = CGPoint(x: xPos, y: yPos + 80)
        target.name = "target"
        addChild(target)
        
        target.physicsBody = SKPhysicsBody(texture: target.texture!, size: target.size)
        
        target.physicsBody?.velocity = CGVector(dx: velocity, dy: 0)
        target.physicsBody?.linearDamping = 0
        
        objectsCreated += 1
        
        if objectsCreated % changeInterval == 0 {
            levelUp()
        }
    }
    
    func levelUp() {
        gameTimer?.invalidate()
        
        print("Game got harder")
        if timerInterval >= 0.8 {
            timerInterval -= timerReductionFactor
        }
        if changeInterval >= 8 {
            changeInterval -= 2
        }
        
        gameTimer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }
    
    override func update(_ currentTime: TimeInterval) {
        removeEnemies()
    }
    
    func removeEnemies(all: Bool = false) {
        for node in children {
            if node.name == "target" {
                if node.position.x >= 1100 || all {
                    node.removeFromParent()
                    score -= 1
                }
            }
        }
    }
}
