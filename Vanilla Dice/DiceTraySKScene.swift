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
    private var colorSkin = ColorSkin.vanilla
    private var lastShakeDate = Date()
    private var dieNodes: [DieShapeNode] = []
    private var spawnPoint: CGPoint {
        CGPoint(x: size.width / 2, y: size.height / 2)
    }
        
    var trayDisplayDelegate: TrayDisplayDelegate?
    
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
        backgroundColor = colorSkin.fillColor
        
        let sceneEdge = SKPhysicsBody(edgeLoopFrom: frame)
        sceneEdge.restitution = 1
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
        
        trayDisplayDelegate?.displayTotal(value: rollTotal)
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
        trayDisplayDelegate?.dieNodesUpdated(dieNodes: dieNodes)
        removeAllChildren()
    }
    
    func addDie(_ dieType: DieType) {
        // Cycle through the colors in the skin
        var color: UIColor?
        if let lastColor = dieNodes.last?.color {
            let index = (colorSkin.diceColors.firstIndex(of: lastColor) ?? 0) + 1
            color = index < colorSkin.diceColors.endIndex ? colorSkin.diceColors[index] : colorSkin.diceColors.first
        } else {
            color = colorSkin.diceColors.randomElement()
        }
        
        let node = DieShapeNode(dieType: dieType, color: color ?? .black)
        node.position = spawnPoint
        node.zRotation = CGFloat.random(in: 0...CGFloat.pi * 2)
        dieNodes.append(node)
        trayDisplayDelegate?.dieNodesUpdated(dieNodes: dieNodes)
        addChild(node)
    }
    
    func rollDice() {
        dieNodes.forEach { dieNode in
            dieNode.roll()
        }
    }
}

protocol TrayDisplayDelegate {
    func displayTotal(value: Int)
    func dieNodesUpdated(dieNodes: [DieShapeNode])
}
