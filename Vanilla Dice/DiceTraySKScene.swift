//
//  DiceTraySKScene.swift
//  Vanilla Dice
//
//  Created by John Reid on 20/4/2023.
//

import CoreMotion
import SpriteKit
import UIKit

class DiceTraySKScene: SKScene, SKPhysicsContactDelegate {
    private let motionManager = CMMotionManager()
    private var lastShakeDate = Date()
    private var dieNodes: [DieShapeNode] = []
    private var spawnPoint: CGPoint {
        CGPoint(x: size.width / 2, y: size.height / 2)
    }
        
    var totalDisplayDelegate: TotalDisplayDelegate?
    
    private func detectShake() {
        if let accelerometerData = motionManager.accelerometerData {
            let shakeThreshold: Double = 3
            let totalAcceleration = sqrt(pow(accelerometerData.acceleration.x, 2) + pow(accelerometerData.acceleration.y, 2) + pow(accelerometerData.acceleration.z, 2))
            
            if totalAcceleration > shakeThreshold,
               Date().timeIntervalSince(lastShakeDate) > 0.07 {
                rollDice()
                lastShakeDate = Date()
            }
        }
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        motionManager.startAccelerometerUpdates()
        backgroundColor = colorFromHex(hex: 0xfefae0)
        
        let sceneEdge = SKPhysicsBody(edgeLoopFrom: frame)
        sceneEdge.restitution = 1.3
        sceneEdge.categoryBitMask = 1
        physicsBody = sceneEdge
               
        addDie(.d20)
    }
    
    override func update(_ currentTime: TimeInterval) {
        detectShake()
        
        dieNodes.forEach { dieNode in
            dieNode.adjustForRotation()
        }
        
        let rollTotal = dieNodes
            .compactMap { dieNode -> Int? in
                let labelText = dieNode.label.text ?? ""
                return Int(labelText)
            }
            .reduce(0, +)
        
        totalDisplayDelegate?.displayTotal(value: rollTotal)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        rollDice()
    }
    
    // Handle physics contact events
    func didBegin(_ contact: SKPhysicsContact) {
        VibrationManager.shared.vibrate()
    }
    
    func clearDice() {
        dieNodes = []
        removeAllChildren()
    }
    
    func addDie(_ dieType: DieType, color: UIColor? = nil) {
        let colorHex: UInt32 = UInt32([0xdda15e, 0x606c38, 0x283618].randomElement() ?? 0xdda15e)
        let node = DieShapeNode(dieType: dieType, color: color ?? colorFromHex(hex: colorHex))
        node.position = spawnPoint
        node.zRotation = CGFloat.random(in: 0...CGFloat.pi * 2)
        dieNodes.append(node)
        addChild(node)
    }
    
    func rollDice() {
        dieNodes.forEach { dieNode in
            dieNode.roll()
        }
    }
}

protocol TotalDisplayDelegate {
    func displayTotal(value: Int)
}
