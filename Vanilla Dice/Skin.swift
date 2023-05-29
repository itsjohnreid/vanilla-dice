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
        case pastel
        case velvet
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
        case Skin.Name.pastel.rawValue:
            return .pastel
        case Skin.Name.velvet.rawValue:
            return .velvet
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
        fillColor: "FEFAE0", // Cornsilk
        borderColor: "9A581F", // Dark brown
        diceColors: [
            "364420", // Dark green
            "747E4D", // Green
            "DDA15E", // Beige
            "C57A34"  // Caramel
        ]
    )
    
    static let forest = Self(
        name: .forest,
        fillColor: "8AB17D", // Olivine
        borderColor: "264653", // Charcoal
        diceColors: [
            "287271", // Myrtle Green
            "E9C46A", // Saffron
            "F4A261", // Sandy Brown
            "E76F51"  // Burnt Sienna
        ]
    )
    
    static let pastel = Self(
        name: .pastel,
        fillColor: "F5DACF", // Pale Dogwood
        borderColor: "F1807E", // Light Coral
        diceColors: [
            "E4B262", // Earth Yellow
            "EDA096", // Melon
            "84A59D", // Cambridge Blue
            "6C8980"  // Hooker's Green
        ]
    )
    
    static let velvet = Self(
        name: .velvet,
        fillColor: "A7392E", // Auburn
        borderColor: "48090B", // Black Bean
        diceColors: [
            "BF6535", // Brown Sugar
            "E09F3E", // Hunyadi Yellow
            "738C7E", // Reseda Green
            "335C67"  // Dark Slate Gray
        ]
    )
}
