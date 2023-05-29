//
//  Settings.swift
//  Vanilla Dice
//
//  Created by John Reid on 26/5/2023.
//

import Foundation

struct Settings {
    private static let userDefaults = UserDefaults.standard
    
    static var skin: String {
        get {
            userDefaults.string(forKey: SettingKey.skinKey.rawValue) ?? Skin.vanilla.name.rawValue
        }
        
        set {
            userDefaults.set(newValue, forKey: SettingKey.skinKey.rawValue)
        }
    }
    
    enum SettingKey: String {
        case skinKey
    }
}
