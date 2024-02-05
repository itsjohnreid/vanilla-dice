//
//  VibrationManager.swift
//  Vanilla Dice
//
//  Created by John Reid on 21/4/2023.
//

import Foundation
import UIKit
import SwiftUI

class VibrationManager {
    static let shared = VibrationManager()
    var lastHeavyVibrationDate = Date()
    var lastLightVibrationDate = Date()
    
    @AppStorage("isVibrationOn") private var isVibrationOn = true
    
    private init() {}
    
    func vibrate(style: UIImpactFeedbackGenerator.FeedbackStyle = .heavy, intensity: CGFloat = 1) {
        guard isVibrationOn else { return }
        
        if style == .heavy {
            guard Date().timeIntervalSince(lastHeavyVibrationDate) > 0.05 else { return }
            lastHeavyVibrationDate = Date()
        } else {
            guard Date().timeIntervalSince(lastLightVibrationDate) > 0.05 else { return }
            lastLightVibrationDate = Date()
        }
        
        UIImpactFeedbackGenerator(style: style).impactOccurred(intensity: intensity)
    }
}
