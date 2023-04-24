//
//  DieShapeNode.swift
//  Vanilla Dice
//
//  Created by John Reid on 19/4/2023.
//

import SpriteKit

class DieShapeNode: SKShapeNode {
    let label: SKLabelNode
    private let shadow: SKNode
    private let shadowShape: SKShapeNode
    private let dieType: DieType
    private var lastRollDate = Date()
    var isRolling = false
    
    init(dieType: DieType, color: UIColor, fontColor: UIColor = .white) {
        self.dieType = dieType
        label = SKLabelNode(text: " " + dieType.name + " ")
        shadowShape = SKShapeNode()
        shadow = SKNode()
        super.init()
        
        // Drawing
        path = dieType.path()
        lineWidth = 16
        fillColor = color
        strokeColor = color
        lineJoin = .round
        
        // Physics
        physicsBody = SKPhysicsBody(polygonFrom: dieType.path())
        physicsBody?.mass = 0.05
        physicsBody?.isDynamic = true
        physicsBody?.friction = 0.2
        physicsBody?.restitution = 1
        physicsBody?.categoryBitMask = 1
        physicsBody?.contactTestBitMask = 1
        physicsBody?.linearDamping = 6
        physicsBody?.angularDamping = 6
        
        // Set up label
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.fontName = "Avenir-Heavy"
        label.fontSize = 72
        label.fontColor = fontColor
        label.alpha = 0.2
        addChild(label)
        
        // Set up shadow
        shadow.zPosition = -1
        addChild(shadow)
        
        shadowShape.path = dieType.path()
        shadowShape.fillColor = .black
        shadowShape.strokeColor = .black
        shadowShape.lineWidth = 0
        shadowShape.lineJoin = .round
        shadowShape.alpha = 0.2
        shadowShape.position = CGPoint(x: 16, y: -24)
        shadow.addChild(shadowShape)
    }
    
    func adjustForRotation() {
        guard let physicsBody else { return }
        if physicsBody.velocity != CGVector.zero,
           physicsBody.angularVelocity > 0.5 || physicsBody.angularVelocity < -0.5
        {
            if Date().timeIntervalSince(lastRollDate) > 0.05 {
                label.alpha = 0.9
                label.text = randomNumber(range: dieType.range)
                VibrationManager.shared.vibrate(style: .light, intensity: 0.75)
                lastRollDate = Date()
            }
        } else {
            isRolling = false
        }
        
        label.zRotation = -zRotation
        shadow.zRotation = -zRotation
        shadowShape.zRotation = zRotation
    }
    
    func roll() {
        let angle = CGFloat.random(in: 0...(.pi * 2))
        let dx = cos(angle) * 400
        let dy = sin(angle) * 400
        
        physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
        physicsBody?.applyAngularImpulse(0.5)
        isRolling = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
