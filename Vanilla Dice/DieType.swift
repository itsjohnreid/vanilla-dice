//
//  DieType.swift
//  Vanilla Dice
//
//  Created by John Reid on 22/4/2023.
//

import CoreGraphics

enum DieType: String, CaseIterable, Identifiable {
    case d4
    case d6
    case d8
    case d10
    case d12
    case d20
    case d100
    
    var id: Self {
        return self
    }
    
    var range: ClosedRange<Int> {
        switch self {
        case .d4: return 1...4
        case .d6: return 1...6
        case .d8: return 1...8
        case .d10: return 1...10
        case .d12: return 1...12
        case .d20: return 1...20
        case .d100: return 1...100
        }
    }
    
    func path(radius: CGFloat = 120) -> CGPath {
        switch self {
        case .d4: return regularShapePath(sides: 3, radius: radius)
        case .d6: return regularShapePath(sides: 4, radius: radius)
        case .d8: return rhombusPath(radius: radius)
        case .d10: return longHexPath(radius: radius)
        case .d12: return regularShapePath(sides: 5, radius: radius)
        case .d20: return regularShapePath(sides: 6, radius: radius)
        case .d100: return regularShapePath(sides: 10, radius: radius)
        }
    }
}

// MARK: - CGPaths

extension DieType {
    func regularShapePath(sides: Int, radius: CGFloat = 120) -> CGPath {
        let path = CGMutablePath()
        let angleIncrement = CGFloat.pi / (CGFloat(sides) / 2)
        
        for i in 0..<sides {
            let angle = angleIncrement * CGFloat(i)
            let pointX = radius * cos(angle)
            let pointY = radius * sin(angle)
            let point = CGPoint(x: pointX, y: pointY)
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.closeSubpath()
        
        return path
    }
    
    func rhombusPath(radius: CGFloat = 135) -> CGPath {
        let path = CGMutablePath()
        let shortRadius = radius * 0.7
        
        path.move(to: CGPoint(x: 0, y: -radius))
        path.addLine(to: CGPoint(x: shortRadius, y: 0))
        path.addLine(to: CGPoint(x: 0, y: radius))
        path.addLine(to: CGPoint(x: -shortRadius, y: 0))
        path.closeSubpath()
        
        return path
    }
    
    func longHexPath(radius: CGFloat = 120) -> CGPath {
        let path = CGMutablePath()
        let shortRadius = radius * 0.3
        let mediumRadius = radius * 0.8
        
        path.move(to: CGPoint(x: 0, y: -mediumRadius))
        path.addLine(to: CGPoint(x: radius, y: -shortRadius))
        path.addLine(to: CGPoint(x: radius, y: shortRadius))
        path.addLine(to: CGPoint(x: 0, y: mediumRadius))
        path.addLine(to: CGPoint(x: -radius, y: shortRadius))
        path.addLine(to: CGPoint(x: -radius, y: -shortRadius))
        path.closeSubpath()
        
        return path
    }
}
