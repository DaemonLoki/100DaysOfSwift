//
//  GameScene.swift
//  Marble Maze
//
//  Created by Stefan Blos on 07.08.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

enum CollisionTypes: UInt32 {
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case finish = 16
    case teleport = 32
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    
    var teleportNodes: [SKSpriteNode] = []
    var teleportInCooldown = false
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var isGameOver = false
    
    var lastTouchPosition: CGPoint?
    var motionManager: CMMotionManager!
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        
        loadLevel()
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = .zero
        
        createPlayer()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard isGameOver == false else { return }
        
        #if targetEnvironment(simulator)
        if let currentTouch = lastTouchPosition {
            let diff = CGPoint(x: currentTouch.x - player.position.x, y: currentTouch.y - player.position.y)
            print("Gravity: x: \(diff.x), y: \(diff.y)")
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
        }
        #else
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
        }
        #endif
    }
    
    func playerCollided(with node: SKNode) {
        if node.name == "vortex" {
            player.physicsBody?.isDynamic = false
            isGameOver = true
            score -= 1
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            
            player.run(sequence) { [weak self] in
                self?.createPlayer()
                self?.isGameOver = false
            }
        } else if node.name == "star" {
            node.removeFromParent()
            score += 1
        } else if node.name == "finish" {
            // Show finished slogan
            let gameEndedLabel = SKLabelNode(fontNamed: "Chalkduster")
            gameEndedLabel.horizontalAlignmentMode = .center
            gameEndedLabel.fontSize = 80
            gameEndedLabel.text = "You Win!"
            addChild(gameEndedLabel)
            
            gameEndedLabel.position = CGPoint(x: 512, y: 400)
            
            isGameOver = true
        } else if node.name == "teleport" {
            if teleportInCooldown { return }
            print("telepooooort")
            
            guard let spriteNode = node as? SKSpriteNode else { return }
            guard let destinationNode = findTeleportDestination(for: spriteNode) else { return }
            
            let move = SKAction.move(to: spriteNode.position, duration: 0.25)
            let scaleDown = SKAction.scale(to: 0.0001, duration: 0.25)
            let teleport = SKAction.move(to: destinationNode.position, duration: 0.1)
            let scaleBigger = SKAction.scale(to: 1.5, duration: 0.25)
            let scaleNormal = SKAction.scale(to: 1, duration: 0.25)
            let sequence = SKAction.sequence([move, scaleDown, teleport, scaleBigger, scaleNormal])
            
            teleportInCooldown = true
            player.physicsBody?.isDynamic = false
            player.run(sequence)
            player.physicsBody?.isDynamic = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.teleportInCooldown = false
            }
        }
    }
    
    func findTeleportDestination(for node: SKSpriteNode) -> SKSpriteNode? {
        for n in teleportNodes {
            if n != node {
                return n
            }
        }
        return nil
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player {
            playerCollided(with: nodeB)
        } else if nodeB == player {
            playerCollided(with: nodeA)
        }
    }
    
    func createPlayer() {
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 96, y: 672)
        player.zPosition = 1
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue | CollisionTypes.teleport.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        
        addChild(player)
    }
    
    func loadLevel() {
        guard let levelUrl = Bundle.main.url(forResource: "level1", withExtension: "txt") else {
            fatalError("Could not find level1.txt in the app bundle.")
        }
        
        guard let levelString = try? String(contentsOf: levelUrl) else {
            fatalError("Could not load level1.txt from the app bundle.")
        }
        
        let lines = levelString.components(separatedBy: "\n")
        
        for (row, line) in lines.reversed().enumerated() {
            for (column, letter) in line.enumerated() {
                let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
                
                if letter == "x" {
                    let wallNode = createWallNode(at: position)
                    addChild(wallNode)
                } else if letter == "v" {
                    let vortexNode = createVortexNode(at: position)
                    addChild(vortexNode)
                } else if letter == "s" {
                    let starNode = createStarNode(at: position)
                    addChild(starNode)
                } else if letter == "f" {
                    let finishNode = createFinishNode(at: position)
                    addChild(finishNode)
                } else if letter == "t" {
                    let teleportNode = createTeleportNode(at: position)
                    teleportNodes.append(teleportNode)
                    addChild(teleportNode)
                } else if letter == " " {
                    // empty space, do nothing
                } else {
                    fatalError("Unknown level letter: \(letter)")
                }
            }
        }
    }
    
    func createWallNode(at position: CGPoint) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: "block")
        node.position = position
        
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
        node.physicsBody?.isDynamic = false
        return node
    }
    
    func createVortexNode(at position: CGPoint) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: "vortex")
        node.name = "vortex"
        node.position = position
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        return node
    }
    
    func createStarNode(at position: CGPoint) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: "star")
        node.name = "star"
        node.position = position
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        return node
    }
    
    func createFinishNode(at position: CGPoint) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: "finish")
        node.name = "finish"
        node.position = position
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        return node
    }
    
    func createTeleportNode(at position: CGPoint) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: "teleport")
        node.name = "teleport"
        node.position = position
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        let rotateAction = SKAction.rotate(byAngle: .pi, duration: 0.8)
        let scaleUpAction = SKAction.scale(to: 1.2, duration: 0.5)
        let scaleDownAction = SKAction.scale(to: 0.8, duration: 0.5)
        let scaleCombo = SKAction.sequence([scaleUpAction, scaleDownAction])
        let actionGroup = SKAction.group([rotateAction, scaleCombo])
        node.run(SKAction.repeatForever(actionGroup))
        
        node.physicsBody?.categoryBitMask = CollisionTypes.teleport.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        return node
    }
}
