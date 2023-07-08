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
            NavigationView {
                MainScene()
                    .background {
                        NavigationConfigurator { nc in
                            nc.navigationBar.barTintColor = skinPreference.skin.darkColor
                            nc.navigationBar.isTranslucent = false
                        }
                    }
            }
            .environmentObject(skinPreference)
        }
    }
}
