//
//  GameScene.swift
//  Project 17
//
//  Created by Samuel Shi on 5/1/21.
//

import SpriteKit

class GameScene: SKScene {
  var starField: SKEmitterNode!
  var player: SKSpriteNode!
  var scoreLabel: SKLabelNode!
  
  var possibleEnemies = ["ball", "hammer", "tv"]
  var gameTimer: Timer?
  var isGameOver = false
  
  var score = 0 { didSet { scoreLabel.text = "Score: \(score)" } }
  
  override func didMove(to view: SKView) {
    backgroundColor = .black
    
    starField = SKEmitterNode(fileNamed: "starfield")!
    starField.position = CGPoint(x: 1024, y: 384)
    starField.advanceSimulationTime(10)
    starField.zPosition = -1
    addChild(starField)
    
    player = SKSpriteNode(imageNamed: "player")
    player.position = CGPoint(x: 100, y: 384)
    player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
    player.physicsBody?.contactTestBitMask = 1
    addChild(player)
    
    scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    scoreLabel.position = CGPoint(x: 16, y: 16)
    scoreLabel.horizontalAlignmentMode = .left
    score = 0
    addChild(scoreLabel)
    
    physicsWorld.gravity = .zero
    physicsWorld.contactDelegate = self
    
    gameTimer = Timer.scheduledTimer(
      timeInterval: 0.35,
      target: self,
      selector: #selector(createEnemy),
      userInfo: nil,
      repeats: true)
  }
  
  @objc func createEnemy() {
    guard let enemy = possibleEnemies.randomElement() else { return }
    
    let sprite = SKSpriteNode(imageNamed: enemy)
    sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
    addChild(sprite)
    
    sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
    sprite.physicsBody?.velocity        = CGVector(dx: -500, dy: 0)
    sprite.physicsBody?.categoryBitMask = 1
    sprite.physicsBody?.angularVelocity = 5
    sprite.physicsBody?.linearDamping   = 0
    sprite.physicsBody?.angularDamping  = 0
  }
  
  override func update(_ currentTime: TimeInterval) {
    for node in children {
      if node.position.x <= -300 {
        node.removeFromParent()
      }
    }
    
    if !isGameOver { score += 1}
  }
}

extension GameScene: SKPhysicsContactDelegate {
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
    addChild(explosion)
    
    player.removeFromParent()
    isGameOver = true
  }
}