//
//  WhackSlot.swift
//  Project 14
//
//  Created by Samuel Shi on 4/20/21.
//

import SpriteKit

class WhackSlot: SKNode {
  var charNode: SKSpriteNode!
  
  var isHit: Bool = false
  var isVisible: Bool = false
  
  func configure(at position: CGPoint) {
    self.position = position
    
    let sprite = SKSpriteNode(imageNamed: "whackHole")
    addChild(sprite)
    
    let cropNode = SKCropNode()
    cropNode.position = CGPoint(x: 0, y: 15)
    cropNode.zPosition = 1
    cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
    
    charNode = SKSpriteNode(imageNamed: "penguinGood")
    charNode.position = CGPoint(x: 0, y: -90)
    charNode.name = "character"
    cropNode.addChild(charNode)
    
    addChild(cropNode)
  }
  
  func show(hideTime: Double) {
    if isVisible { return }
    emitMud()
    
    charNode.xScale = 1
    charNode.yScale = 1
    
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
    
    DispatchQueue.main.asyncAfter(deadline: .now() + (3.5 * hideTime)) { [weak self] in
      self?.hide()
    }
  }
  
  func hide() {
    if !isVisible { return }
    emitMud()
    
    charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
    isVisible = false
  }
  
  func hit() {
    isHit = true
    
    let delay = SKAction.wait(forDuration: 0.25)
    let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
    let notVisible = SKAction.run { [weak self] in
      self?.isVisible = false
    }
    
    let sequence = SKAction.sequence([delay, hide, notVisible])
    charNode.run(sequence)
    
    emitSmoke()
  }
  
  func emitSmoke() {
    guard let smokeParticle = SKEmitterNode(fileNamed: "Smoke") else { return }
    smokeParticle.position = position
    
    let smokeSequence = SKAction.sequence([
      SKAction.run { [weak self] in self?.addChild(smokeParticle) },
      SKAction.wait(forDuration: 3),
      SKAction.run { smokeParticle.removeFromParent() },
    ])
    
    run(smokeSequence)
  }
  
  func emitMud() {
    guard let mudParticle = SKEmitterNode(fileNamed: "Mud") else { return }
    mudParticle.position  = CGPoint(x: 0, y: 0)
    mudParticle.zPosition = 0
    
    let mudSequence = SKAction.sequence([
      SKAction.run { [weak self] in self?.addChild(mudParticle) },
      SKAction.wait(forDuration: 3),
      SKAction.run { mudParticle.removeFromParent() },
    ])
    
    run(mudSequence)
  }
}
