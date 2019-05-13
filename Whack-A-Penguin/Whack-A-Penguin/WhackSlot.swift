//
//  WhackSlot.swift
//  Whack-A-Penguin
//
//  Created by Stefan Blos on 11.05.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//
import SpriteKit
import UIKit

class WhackSlot: SKNode {
    
    var isVisible = false
    var isHit = false
    
    var charNode: SKSpriteNode!
    
    func configure(at position: CGPoint) {
        self.position = position
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.name = "cropNode"
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        cropNode.addChild(charNode)
        
        addChild(cropNode)
    }
    
    func show(hideTime: Double) {
        if isVisible { return }
        
        charNode.xScale = 1
        charNode.yScale = 1
        
        playMudEffect()
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        
        isVisible = true
        isHit = false
        
        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        } else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) { [weak self] in
            self?.hide()
        }
    }
    
    func hide() {
        if !isVisible { return }
        playMudEffect()
        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        isVisible = false
    }
    
    func hit() {
        isHit = true
        
        if let smokeParticles = SKEmitterNode(fileNamed: "smoke_emitter") {
            let charPosition = charNode.position
            smokeParticles.name = "smoke"
            smokeParticles.position = CGPoint(x: charPosition.x, y: charPosition.y + 20)
                
            addChild(smokeParticles)
            let smokeDelay = SKAction.wait(forDuration: 3)
            let removeSmoke = SKAction.run { [unowned self] in
                self.childNode(withName: "smoke")?.removeFromParent()
            }
            charNode.run(SKAction.sequence([smokeDelay, removeSmoke]))
        }
        
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisible = SKAction.run {[unowned self] in self.isVisible = false }
        charNode.run(SKAction.sequence([delay, hide, notVisible]))
    }
    
    func playMudEffect() {
        if let mudParticles = SKEmitterNode(fileNamed: "mud_emitter") {
            let charPosition = charNode.position
            mudParticles.name = "mud"
            if isVisible == false {
                mudParticles.position = CGPoint(x: charPosition.x, y: charPosition.y + 80)
            } else {
                mudParticles.position = CGPoint(x: charPosition.x, y: charPosition.y)
            }
            
            
            addChild(mudParticles)
            
            let mudDelay = SKAction.wait(forDuration: 3)
            let removeMud = SKAction.run { [unowned self] in
                self.childNode(withName: "mud")?.removeFromParent()
            }
            charNode.run(SKAction.sequence([mudDelay, removeMud]))
        }
    }
}
