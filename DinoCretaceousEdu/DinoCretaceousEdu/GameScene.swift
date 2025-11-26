//
//  GameScene.swift
//  DinoCretaceousEdu
//

import SpriteKit
import Foundation

extension Notification.Name {
    static let gameOver = Notification.Name("GAME_OVER")
}

class GameScene: SKScene, SKPhysicsContactDelegate {

    weak var gameState: GameState?

    struct PhysicsCategory {
        static let none: UInt32   = 0
        static let dino: UInt32   = 0b1
        static let ground: UInt32 = 0b10
        static let orb: UInt32    = 0b100
        static let hazard: UInt32 = 0b1000
    }

    private var dino: SKSpriteNode!

    private var lastOrbSpawn: TimeInterval = 0
    private var lastHazardSpawn: TimeInterval = 0

    private var hasGameEnded: Bool = false

    // MARK: - Scene Setup

    override func didMove(to view: SKView) {
        lastOrbSpawn = 0
        lastHazardSpawn = 0
        hasGameEnded = false

        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = self

        backgroundColor = SKColor(red: 0.75, green: 0.9, blue: 1.0, alpha: 1)

        setupGround()
        setupDino()
    }

    private func setupGround() {
        let ground = SKNode()
        ground.position = CGPoint(x: size.width / 2, y: 50)

        let body = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: 100))
        body.isDynamic = false
        body.categoryBitMask = PhysicsCategory.ground
        body.contactTestBitMask = PhysicsCategory.dino

        ground.physicsBody = body
        addChild(ground)

        let sprite = SKSpriteNode(color: .brown,
                                  size: CGSize(width: size.width, height: 50))
        sprite.position = CGPoint(x: size.width / 2, y: 25)
        addChild(sprite)
    }

    // MARK: - Dino Sprite

    private func setupDino() {
        // Replace this with your dino image
        dino = SKSpriteNode(imageNamed: "dino_idle")
        dino.size = CGSize(width: 100, height: 100)
        dino.position = CGPoint(x: size.width * 0.2, y: 200)

        let body = SKPhysicsBody(texture: dino.texture!, size: dino.size)
        body.allowsRotation = false
        body.categoryBitMask = PhysicsCategory.dino
        body.collisionBitMask = PhysicsCategory.ground
        body.contactTestBitMask = PhysicsCategory.orb |
                                  PhysicsCategory.hazard |
                                  PhysicsCategory.ground

        dino.physicsBody = body
        addChild(dino)
    }

    // MARK: - Spawning Orb

    private func spawnOrb() {
        guard !hasGameEnded, let gameState else { return }

        let orb = SKSpriteNode(imageNamed: "orb_item")
        orb.size = CGSize(width: 50, height: 50)
        orb.position = CGPoint(x: size.width + 40,
                               y: CGFloat.random(in: 200...650))

        orb.physicsBody = SKPhysicsBody(texture: orb.texture!, size: orb.size)
        orb.physicsBody?.isDynamic = false
        orb.physicsBody?.categoryBitMask = PhysicsCategory.orb
        orb.physicsBody?.contactTestBitMask = PhysicsCategory.dino

        addChild(orb)

        let speed = max(1.0, gameState.currentDifficulty)
        orb.run(.sequence([
            SKAction.moveTo(x: -40, duration: 6.0 / speed),
            .removeFromParent()
        ]))
    }

    // MARK: - Spawning Hazard (Cactus)

    private func spawnHazard() {
        guard !hasGameEnded, let gameState else { return }

        let hazard = SKSpriteNode(imageNamed: "cactus_hazard")
        hazard.size = CGSize(width: 70, height: 90)
        hazard.position = CGPoint(x: size.width + 70, y: 120)

        hazard.physicsBody = SKPhysicsBody(texture: hazard.texture!, size: hazard.size)
        hazard.physicsBody?.isDynamic = false
        hazard.physicsBody?.categoryBitMask = PhysicsCategory.hazard
        hazard.physicsBody?.contactTestBitMask = PhysicsCategory.dino

        addChild(hazard)

        let speed = max(1.0, gameState.currentDifficulty)
        hazard.run(.sequence([
            SKAction.moveTo(x: -40, duration: 4.0 / speed),
            .removeFromParent()
        ]))
    }

    // MARK: - Game Loop

    override func update(_ time: TimeInterval) {
        guard !hasGameEnded else { return }

        if time - lastOrbSpawn > 2 {
            lastOrbSpawn = time
            spawnOrb()
        }

        if time - lastHazardSpawn > 3 {
            lastHazardSpawn = time
            spawnHazard()
        }

        if dino.position.y < -200 {
            handleHazardHit()
        }
    }

    // MARK: - Controls (Tap to Jump)

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !hasGameEnded else { return }

        if let body = dino.physicsBody, body.velocity.dy == 0 {
            body.applyImpulse(CGVector(dx: 0, dy: 240))   // Reduced jump
        }
    }

    // MARK: - Collision Handling

    func didBegin(_ contact: SKPhysicsContact) {
        guard !hasGameEnded else { return }

        let a = contact.bodyA.categoryBitMask
        let b = contact.bodyB.categoryBitMask

        // Orb
        if (a == PhysicsCategory.dino && b == PhysicsCategory.orb)
            || (a == PhysicsCategory.orb && b == PhysicsCategory.dino) {

            (a == PhysicsCategory.orb ? contact.bodyA.node : contact.bodyB.node)?
                .removeFromParent()

            handleOrbCollected()
        }

        // Hazard
        if (a == PhysicsCategory.dino && b == PhysicsCategory.hazard)
            || (a == PhysicsCategory.hazard && b == PhysicsCategory.dino) {

            (a == PhysicsCategory.hazard ? contact.bodyA.node : contact.bodyB.node)?
                .removeFromParent()

            handleHazardHit()
        }
    }

    // MARK: - Game Logic

    private func handleOrbCollected() {
        guard let gameState else { return }

        gameState.score += 10
        gameState.totalOrbsCollected += 1
        
        let elapsed = gameState.currentSessionDuration()
        let ml = DifficultyPredictor()
        
        let newDiff = ml.predictDifficulty(
            score: gameState.score,
            lives: gameState.lives,
            orbsCollected: gameState.totalOrbsCollected,
            hazardHits: gameState.totalHazardHits,
            elapsedTime: elapsed,
            baseDifficulty: gameState.baseDifficulty
        )
        gameState.currentDifficulty = newDiff
    }

    private func handleHazardHit() {
        guard let gameState else { return }

        gameState.lives -= 1
        gameState.totalHazardHits += 1

        // Dino flash animation
        dino.run(.sequence([
            SKAction.scale(to: 1.2, duration: 0.1),
            SKAction.scale(to: 1.0, duration: 0.1)
        ]))

        if gameState.lives <= 0 {
            gameOver()
        }
    }

    private func gameOver() {
        hasGameEnded = true
        NotificationCenter.default.post(name: .gameOver, object: nil)
    }
}
