//
//  Skin.swift
//  Vanilla Dice
//
//  Created by John Reid on 25/4/2023.
//

import SwiftUI
import UIKit

struct Skin: Equatable {
    let name: Name
    let lightColor: UIColor
    let darkColor: UIColor
    let diceColors: [UIColor]
    
    enum Name: String, Codable {
        case vanilla
        case forest
        case fireball
        case pastel
        case cosmic
        case arcane
    }
}

class SkinPreference: ObservableObject {
    @Published var skin: Skin = Skin.preference
}

extension Skin {
    static var preference: Skin {
        switch Settings.skin {
        case Skin.Name.vanilla.rawValue:
            return .vanilla
        case Skin.Name.forest.rawValue:
            return .forest
        case Skin.Name.fireball.rawValue:
            return .fireball
        case Skin.Name.pastel.rawValue:
            return .pastel
        case Skin.Name.cosmic.rawValue:
            return .cosmic
        case Skin.Name.arcane.rawValue:
            return .arcane
        default:
            return .vanilla
        }
    }
}

extension Skin {
    init(name: Skin.Name, fillColor: String, borderColor: String, diceColors: [String]) {
        self.name = name
        self.lightColor = .init(hex: fillColor)
        self.darkColor = .init(hex: borderColor)
        self.diceColors = diceColors.map { .init(hex: $0) }
    }
    
    static let vanilla = Self(
        name: .vanilla,
        fillColor: "F2E6C8", // Pearl
        borderColor: "844F20", // Russet
        diceColors: [
            "ACAC83", // Sage
            "747E4D", // Reseda Green
            "D79F5D", // Earth Yellow
            "B77E44"  // Copper
        ]
    )
    
    static let forest = Self(
        name: .forest,
        fillColor: "8AB17D", // Olivine
        borderColor: "23404B", // Charcoal
        diceColors: [
            "89C7B9", // Tiffany Blue
            "6AAFAA", // Verdigris
            "4D8774", // Viridian
            "276668"  // Caribbean Current
        ]
    )
    
    static let fireball = Self(
        name: .fireball,
        fillColor: "F1CF8C", // Sunset
        borderColor: "C32424", // Fire Engine Red
        diceColors: [
            "FBAF37", // Orange
            "F58518", // Tangerine
            "EF6A0A", // Spanish Orange
            "E34919"  // Flame
        ]
    )
    
    static let pastel = Self(
        name: .pastel,
        fillColor: "F8EDEB", // Seashell
        borderColor: "FF8785", // Light Red
        diceColors: [
            "D0DCD5", // Platinum
            "E7E4DC", // Alabaster
            "FFD7BA", // Apricot
            "FEC89A"  // Peach
        ]
    )
    
    static let cosmic = Self(
        name: .cosmic,
        fillColor: "F8F9FA", // Seasalt
        borderColor: "131516", // Night
        diceColors: [
            "ADB5BD", // French Gray
            "7B838A", // Slate Gray
            "495057", // Outer Space
            "212529"  // Eerie Black
        ]
    )
    
    static let arcane = Self(
        name: .arcane,
        fillColor: "F9F8F8", // Seasalt
        borderColor: "5A1664", // Palatinate
        diceColors: [
            "B391B0", // Lilac
            "AA6DA3", // Sky magenta
            "AE43B6", // Purpureus
            "B118C8"  // Dark Violet
        ]
    )
}
