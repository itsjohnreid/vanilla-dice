//
//  MainApp.swift
//  Vanilla Dice
//
//  Created by John Reid on 17/4/2023.
//

import SwiftUI

@main
struct MainApp: App {
    @StateObject var skinPreference = SkinPreference()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                    MainScene()
            }
            .environmentObject(skinPreference)
            .tint(.white)
        }
    }
}
