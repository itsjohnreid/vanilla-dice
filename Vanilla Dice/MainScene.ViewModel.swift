//
//  MainScene.ViewModel.swift
//  Vanilla Dice
//
//  Created by John Reid on 29/5/2023.
//

import Foundation

extension MainScene {
    class ViewModel: ObservableObject {
        let skScene = DiceTraySKScene(size: CGSize(width: 100, height: 100))
    }
}
