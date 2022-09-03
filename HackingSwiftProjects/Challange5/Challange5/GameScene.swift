//
//  GameScene.swift
//  Challange5
//
//  Created by DongKyu Kim on 2022/09/03.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    var starfield: SKEmitterNode!
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var bulletNode: SKLabelNode!
    var bulletCount = 6 {
        didSet {
            bulletNode.text = ""
            if bulletCount > 0 {
                for _ in 0..<bulletCount {
                    bulletNode.text! += "🧨"
                }
            } else {
                bulletNode.text = "Tap elsewhere to Reload"
            }

        }
    }
    
    let enemies = ["blue", "green", "orange"]
    var isGameOver = false
    var gameTimer: Timer?
    var enemyTimer: Timer?
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        score = 0
        
        bulletNode = SKLabelNode(fontNamed: "")
        bulletNode.position = CGPoint(x: 16, y: 700)
        bulletNode.horizontalAlignmentMode = .left
        addChild(bulletNode)
        
        bulletCount = 6
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        gameTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(showGameOver), userInfo: nil, repeats: false)
        enemyTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        if !nodes(at: location).isEmpty {
            let target = nodes(at: location)[0]
            if target.name == "orange" {
                score += 10
            } else if target.name == "green" {
                score += 5
            } else if target.name == "blue" {
                score += 1
            }
            
            target.removeFromParent()
            bulletCount -= 1
        } else {
            self.bulletNode.text = "Reloading..."
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.bulletCount = 6
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.y > frame.height * 2 / 3 || node.position.y < frame.height / 3 {
                
            }
        }
    }
    
// MARK: @objc functions
    @objc func showGameOver() {
        for node in children {
            node.removeFromParent()
        }
        
        enemyTimer?.invalidate()
        
        let gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        gameOverLabel.fontSize = 50
        gameOverLabel.text = "Game Over!"
        gameOverLabel.horizontalAlignmentMode = .center
        
        
        scoreLabel.position = CGPoint(x: gameOverLabel.position.x, y: gameOverLabel.position.y - 50)
        scoreLabel.horizontalAlignmentMode = .center

        addChild(gameOverLabel)
        addChild(scoreLabel)
    }
    
    @objc func createEnemy() {
        
        if !isGameOver {
            guard let enemy = enemies.randomElement() else { return }
            
            let sprite = SKSpriteNode(imageNamed: enemy)
            var direction: Int!
            
            sprite.name = enemy
            
            if sprite.name == "orange" {
                sprite.size = CGSize(width: 50, height: 50)
            } else if sprite.name == "green" {
                sprite.size = CGSize(width: 100, height: 100)
            } else if sprite.name == "blue" {
                sprite.size = CGSize(width: 200, height: 100)
            }
            

            sprite.position.y = CGFloat(Int.random(in: 50...736))
            if sprite.position.y > 262 && sprite.position.y < 524 {
                sprite.position.x = CGFloat(1074)
                direction = -1
            } else {
                sprite.position.x = CGFloat(-50)
                direction = 1
            }
            addChild(sprite)
            
            sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
            sprite.physicsBody?.categoryBitMask = 1
            sprite.physicsBody?.velocity = CGVector(dx: direction * 500, dy: 0)
            sprite.physicsBody?.angularVelocity = 1
            sprite.physicsBody?.linearDamping = 0
            sprite.physicsBody?.angularDamping = 0
        }
    }
}
