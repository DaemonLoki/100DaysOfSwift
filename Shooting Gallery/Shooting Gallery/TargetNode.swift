//
//  TargetNode.swift
//  Shooting Gallery
//
//  Created by Stefan Blos on 27.05.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

import SpriteKit

class TargetNode: SKNode {
    
    var isHit = false
    
    func configure(at position: CGPoint) {
        self.position = position
        self.name = "target"
        
        let sprite = SKSpriteNode(imageNamed: "target0")
        sprite.name = "sprite"
        addChild(sprite)
    }
    
    func addPhysicsBody() {
        guard let sprite = childNode(withName: "sprite") as? SKSpriteNode else { return }
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.velocity = CGVector(dx: 120, dy: 0)
        sprite.physicsBody?.linearDamping = 0
    }
    
    func hit() {
        self.removeFromParent()
    }
    
}
