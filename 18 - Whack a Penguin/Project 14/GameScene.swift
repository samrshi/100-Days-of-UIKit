//
//  GameScene.swift
//  Project 14
//
//  Created by Samuel Shi on 4/20/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
  var slots = [WhackSlot]()
  var gameScore: SKLabelNode!
  
  var popupTime = 0.85
  var numRounds = 0
  
  var score: Int = 0 {
    didSet { gameScore.text = "Score: \(score)" }
  }
  
  override func didMove(to view: SKView) {
    removeAllChildren()

    let background = SKSpriteNode(imageNamed: "whackBackground")
    background.position = CGPoint(x: 512, y: 384)
    background.blendMode = .replace
    background.zPosition = -1
    addChild(background)
    
    gameScore = SKLabelNode(fontNamed: "Chalkduster")
    gameScore.text = "Score: 0"
    gameScore.position = CGPoint(x: 8, y: 8)
    gameScore.horizontalAlignmentMode = .left
    gameScore.fontSize = 48
    addChild(gameScore)
    
    popupTime = 0.85
    numRounds = 0
    slots = []
    score = 0
    
    for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 410)) }
    for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 320)) }
    for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 230)) }
    for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 140)) }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
      self?.createEnemy()
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    let tappedNodes = nodes(at: location)
    
    for node in tappedNodes {
      if node.name == "resetLabel" {
        didMove(to: view!)
        continue
      }
      
      guard let whackSlot = node.parent?.parent as? WhackSlot else { continue }
      if !whackSlot.isVisible { continue }
      if whackSlot.isHit { continue }
      
      whackSlot.hit()

      if node.name == "charFriend" {
        score -= 5
        run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
      } else if node.name == "charEnemy" {
        whackSlot.charNode.xScale = 0.85
        whackSlot.charNode.yScale = 0.85
        score += 1
        run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
      }
    }
  }
  
  func createSlot(at position: CGPoint) {
    let slot = WhackSlot()
    slot.configure(at: position)
    addChild(slot)
    slots.append(slot)
  }
  
  func createEnemy() {
    numRounds += 1
    
    guard numRounds < 30 else {
      gameOver()
      return
    }
    
    popupTime *= 0.991
    
    slots.shuffle()
    slots[0].show(hideTime: popupTime)
    
    if Int.random(in: 0...12) > 4  { slots[1].show(hideTime: popupTime) }
    if Int.random(in: 0...12) > 8  { slots[2].show(hideTime: popupTime) }
    if Int.random(in: 0...12) > 10 { slots[3].show(hideTime: popupTime) }
    if Int.random(in: 0...12) > 11 { slots[4].show(hideTime: popupTime) }
    
    let minDelay = popupTime / 2.0
    let maxDelay = popupTime * 2.0
    let delay = Double.random(in: minDelay...maxDelay)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
      self?.createEnemy()
    }
  }
  
  func gameOver() {
    // challenge 1
    run(SKAction.playSoundFileNamed("gameover.mp3", waitForCompletion: false))
    
    for slot in slots { slot.hide() }
    
    let gameOver = SKSpriteNode(imageNamed: "gameOver")
    gameOver.position = CGPoint(x: 512, y: 384)
    gameOver.zPosition = 1
    addChild(gameOver)
    
    // challenge 2
    let scoreLabel = SKLabelNode(fontNamed: "Courier-Bold")
    scoreLabel.text = "Score: \(score)"
    scoreLabel.position = CGPoint(x: 512, y: 320)
    scoreLabel.zPosition = 2
    scoreLabel.fontSize = 40
    addChild(scoreLabel)
    
    let resetLabel = SKLabelNode(fontNamed: "Courier-Bold")
    resetLabel.text = "> New Game <"
    resetLabel.name = "resetLabel"
    resetLabel.position = CGPoint(x: 512, y: 280)
    resetLabel.zPosition = 2
    resetLabel.fontSize = 30
    addChild(resetLabel)
  }
}
