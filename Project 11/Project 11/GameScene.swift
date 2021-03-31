//
//  GameScene.swift
//  Project 11
//
//  Created by Samuel Shi on 3/31/21.
//

import SpriteKit

class GameScene: SKScene {
  override func didMove(to view: SKView) {
    let background = SKSpriteNode(imageNamed: "background")
    background.position = CGPoint(x: 512, y: 384)
    background.blendMode = .replace
    background.zPosition = -1
    addChild(background)
    
    physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    
    for i in 0..<5 {
      makeBouncer(at: CGPoint(x: i * 256, y: 0))
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    
    let ball = SKSpriteNode(imageNamed: "ballRed")
    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
    ball.physicsBody?.restitution = 0.4
    ball.position = location
    addChild(ball)
  }
  
  func makeBouncer(at position: CGPoint) {
    let bouncer = SKSpriteNode(imageNamed: "bouncer")
    bouncer.position = position
    bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
    bouncer.physicsBody?.isDynamic = false
    addChild(bouncer)
  }
}
