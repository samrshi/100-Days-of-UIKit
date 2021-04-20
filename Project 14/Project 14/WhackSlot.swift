//
//  WhackSlot.swift
//  Project 14
//
//  Created by Samuel Shi on 4/20/21.
//

import SpriteKit

class WhackSlot: SKNode {
  var charNode: SKSpriteNode!
  
  var isVisible: Bool = false
  var isHit: Bool = false
  
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
    
    charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
    isVisible = true
    isHit = false
    
    if Int.random(in: 0...2) == 0 {
      charNode.texture = SKTexture(imageNamed: "penguinGood")
      charNode.name = "charFriend"
    } else {
      charNode.texture = SKTexture(imageNamed: "penguinEvil")
      charNode.name = "charEven"
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + (3.5 * hideTime)) { [weak self] in
      self?.hide()
    }
  }
  
  func hide() {
    if !isVisible { return }
    
    charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
    isVisible = false
  }
}
