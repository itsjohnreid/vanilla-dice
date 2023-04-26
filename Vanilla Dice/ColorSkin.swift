//
//  ColorSkin.swift
//  Vanilla Dice
//
//  Created by John Reid on 25/4/2023.
//

import UIKit

struct ColorSkin {
    let fillColor: UIColor
    let borderColor: UIColor
    let diceColors: [UIColor]
}

extension ColorSkin {
    init(fillColor: UInt32, borderColor: UInt32, diceColors: [UInt32]) {
        self.fillColor = colorFromHex(hex: fillColor)
        self.borderColor = colorFromHex(hex: borderColor)
        self.diceColors = diceColors.map { colorFromHex(hex: $0) }
    }
    
    static let vanilla = Self(
        fillColor: 0xFEFAE0, // Cornsilk
        borderColor: 0x9A581F, // Dark brown
        diceColors: [
            0x364420, // Dark green
            0x747E4D, // Green
            0xDDA15E, // Beige
            0xC57A34  // Caramel
        ]
    )
    
    static let forest = Self(
        fillColor: 0x8AB17D, // Olivine
        borderColor: 0x264653, // Charcoal
        diceColors: [
            0x287271, // Myrtle Green
            0xE9C46A, // Saffron
            0xF4A261, // Sandy Brown
            0xE76F51  // Burnt Sienna
        ]
    )
    
    static let pastel = Self(
        fillColor: 0xF5DACF, // Pale Dogwood
        borderColor: 0xF1807E, // Light Coral
        diceColors: [
            0xE4B262, // Earth Yellow
            0xEDA096, // Melon
            0x84A59D, // Cambridge Blue
            0x6C8980  // Hooker's Green
        ]
    )
}

// Template
//
//    static let name = Self(
//        fillColor: 0x, // Name
//        borderColor: 0x, // Name
//        diceColors: [
//            0x, // Name
//            0x, // Name
//            0x, // Name
//            0x  // Name
//        ]
//    )
