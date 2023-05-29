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
    private var skin: Skin { Skin.preference }
    private var lastShakeDate = Date()
    private var lastColor: UIColor?
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
        backgroundColor = skin.lightColor
        motionManager.startAccelerometerUpdates()
        updateBounds()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        view.addGestureRecognizer(tapGesture)
        view.addGestureRecognizer(swipeGesture)
        
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
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        // TODO: Setting
//        rollDice()
    }
    
    @objc func handleSwipe(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .ended:
            let translation = sender.translation(in: view)
            let angle = atan2(translation.y, translation.x)
            rollDice(angle: angle)
        default: break
        }
    }
    
    func updateBounds() {
        let topBoxRect = CGRect(x: -frame.width / 2, y: frame.height, width: frame.width * 2, height: 600)
        let bottomBoxRect = CGRect(x: -frame.width / 2, y: -600, width: frame.width * 2, height: 600)
        let leftBoxRect = CGRect(x: -600, y: -frame.height / 2, width: 600, height: frame.height * 2)
        let rightBoxRect = CGRect(x: frame.width, y: -frame.height / 2, width: 600, height: frame.height * 2)
        
        let topBox = SKPhysicsBody(rectangleOf: topBoxRect.size, center: .init(x: topBoxRect.midX, y: topBoxRect.midY))
        let bottomBox = SKPhysicsBody(rectangleOf: bottomBoxRect.size, center: .init(x: bottomBoxRect.midX, y: bottomBoxRect.midY))
        let leftBox = SKPhysicsBody(rectangleOf: leftBoxRect.size, center: .init(x: leftBoxRect.midX, y: leftBoxRect.midY))
        let rightBox = SKPhysicsBody(rectangleOf: rightBoxRect.size, center: .init(x: rightBoxRect.midX, y: rightBoxRect.midY))
        
        let sceneEdge = SKPhysicsBody(bodies: [topBox, bottomBox, leftBox, rightBox])
        
        sceneEdge.restitution = 1
        sceneEdge.categoryBitMask = 1
        sceneEdge.usesPreciseCollisionDetection = true
        sceneEdge.isDynamic = false
        physicsBody = sceneEdge
    }
    
    func respawnDice() {
        dieNodes.forEach { dieNode in
            dieNode.position = spawnPoint
        }
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
        let node = DieShapeNode(dieType: dieType, color: nextColor)
        node.position = spawnPoint
        node.zRotation = CGFloat.random(in: 0...CGFloat.pi * 2)
        dieNodes.append(node)
        trayDisplayDelegate?.dieNodesUpdated(dieNodes: dieNodes)
        addChild(node)
    }
    
    // Cycle through the colors in the skin
    var nextColor: UIColor {
        var color: UIColor?
        if let lastColor = lastColor {
            let index = (skin.diceColors.firstIndex(of: lastColor) ?? 0) + 1
            color = index < skin.diceColors.endIndex ? skin.diceColors[index] : skin.diceColors.first
        } else {
            color = skin.diceColors.randomElement()
        }
        
        lastColor = color
        return color ?? skin.darkColor
    }
    
    func rollDice(angle: CGFloat? = nil) {
        guard dieNodes.count > 0 else { return }
        dieNodes.forEach { dieNode in
            dieNode.roll(angle: angle)
        }
        trayDisplayDelegate?.shook()
    }
    
    func refreshSkin() {
        backgroundColor = skin.lightColor
        dieNodes.forEach { dieNode in
            dieNode.setColor(color: nextColor)
        }
    }
}

protocol TrayDisplayDelegate {
    func displayTotal(value: Int)
    func dieNodesUpdated(dieNodes: [DieShapeNode])
    func shook()
}
