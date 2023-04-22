//
//  Utils.swift
//  Vanilla Dice
//
//  Created by John Reid on 18/4/2023.
//

import Foundation
import UIKit

func colorFromHex(hex: UInt32, alpha: CGFloat = 1.0) -> UIColor {
    let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
    let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
    let blue = CGFloat(hex & 0x0000FF) / 255.0
    
    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
}

func randomNumber(range: ClosedRange<Int>) -> String {
    let number = Int.random(in: range)
    return "\(number)" // + (number == 6 || number == 9 ? "." : "")
}
