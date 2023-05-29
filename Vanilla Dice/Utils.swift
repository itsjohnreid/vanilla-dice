//
//  Utils.swift
//  Vanilla Dice
//
//  Created by John Reid on 18/4/2023.
//

import Foundation
import UIKit

func randomNumber(range: ClosedRange<Int>) -> String {
    let number = Int.random(in: range)
    return "\(number)" // + (number == 6 || number == 9 ? "." : "")
}

func idealTextColor(for color: UIColor) -> UIColor {
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var alpha: CGFloat = 0.0
    color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    
    // Calculate the luminance value
    let luminance = (0.299 * red + 0.587 * green + 0.114 * blue) * alpha
    
    // Choose black or white text color based on the luminance value
    if luminance > 0.8 {
        return UIColor.black
    } else {
        return UIColor.white
    }
}
