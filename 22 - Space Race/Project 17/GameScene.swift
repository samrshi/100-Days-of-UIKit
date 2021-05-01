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
  var enemyCount = 0
  var gameTimer: Timer?
  var isGameOver = false
  
  var score = 0 {
    didSet { scoreLabel.text = "Score: \(score)" }
  }
  
  override func didMove(to view: SKView) {
    backgroundColor = .black
    
    starField = SKEmitterNode(fileNamed: "starfield")!
    starField.position = CGPoint(x: 1024, y: 384)
    starField.advanceSimulationTime(10)
    starField.zPosition = -1
    starField.name = "starfield"
    addChild(starField)
    
    makePlayer()
    
    scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    scoreLabel.position = CGPoint(x: 16, y: 16)
    scoreLabel.horizontalAlignmentMode = .left
    scoreLabel.name = "scoreLabel"
    score = 0
    addChild(scoreLabel)
    
    physicsWorld.gravity = .zero
    physicsWorld.contactDelegate = self
    
    makeTimer(withInterval: 0.5)
  }
  
  func makePlayer() {
    player = SKSpriteNode(imageNamed: "player")
    player.position = CGPoint(x: 100, y: 384)
    player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
    player.physicsBody?.contactTestBitMask = 1
    player.name = "player"
    addChild(player)
  }
  
  func makeTimer(withInterval interval: Double) {
    gameTimer = Timer.scheduledTimer(
      timeInterval: interval,
      target: self,
      selector: #selector(createEnemy),
      userInfo: nil,
      repeats: true)
  }
  
  @objc func createEnemy() {
    guard !isGameOver, let enemy = possibleEnemies.randomElement() else { return }
    
    let sprite = SKSpriteNode(imageNamed: enemy)
    sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
    sprite.name = "enemy"
    addChild(sprite)
    
    sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
    sprite.physicsBody?.velocity        = CGVector(dx: -500, dy: 0)
    sprite.physicsBody?.categoryBitMask = 1
    sprite.physicsBody?.angularVelocity = 5
    sprite.physicsBody?.linearDamping   = 0
    sprite.physicsBody?.angularDamping  = 0
    
    enemyCount += 1
    guard let interval = gameTimer?.timeInterval else { return }
    if enemyCount % 20 == 0 {
      gameTimer?.invalidate()
      
      let newInterval = interval <= 0.15 ? interval - 0.1 : 0.75
      makeTimer(withInterval: newInterval) // challenge 2
    }
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
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if !isGameOver {
      gameOver() // challenge 1
      return
    }
    
    // bonus: reset game
    guard let location = touches.first?.location(in: self) else { return }
    for node in nodes(at: location) {
      if node.name == "resetGame" {
        node.removeFromParent()
        children.first(where: { $0.name == "gameOver" })?.removeFromParent()
        
        gameTimer?.invalidate()
        makeTimer(withInterval: 1.0)
        isGameOver = false
        enemyCount = 0
        score = 0
        
        if !isGameOver { makePlayer() }
      }
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first, !isGameOver else { return }
    var location = touch.location(in: self)
    
    if location.y < 100 {
      location.y = 100
    } else if location.y > 668 {
      location.y = 668
    }
    
    player.position = location
  }
  
  func didBegin(_ contact: SKPhysicsContact) {
    guard contact.bodyA.node?.name == "player" ||
          contact.bodyB.node?.name == "player" else { return }
    gameOver()
  }
  
  func gameOver() {
    let explosion = SKEmitterNode(fileNamed: "explosion")!
    explosion.position = player.position
    addChild(explosion)
    
    player.removeFromParent()
    isGameOver = true
    
    for child in children { // challenge 3
      if child.name == "enemy" { child.removeFromParent() }
    }
    
    let gameOverLabel = SKLabelNode(fontNamed: "Courier-Bold")
    gameOverLabel.position = CGPoint(x: 512, y: 384)
    gameOverLabel.fontSize = 40
    gameOverLabel.name = "gameOver"
    gameOverLabel.text = "Game Over!"
    addChild(gameOverLabel)

    let resetGameLabel = SKLabelNode(fontNamed: "Courier-Bold")
    resetGameLabel.position = CGPoint(x: 512, y: 280)
    resetGameLabel.fontSize = 30
    resetGameLabel.name = "resetGame"
    resetGameLabel.text = "> NEW GAME <"
    addChild(resetGameLabel)
  }
}
