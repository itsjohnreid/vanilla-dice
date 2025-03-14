//
//  SettingsScene.swift
//  Vanilla Dice
//
//  Created by John Reid on 27/4/2023.
//

import SwiftUI

struct SettingsScene: View {
    @EnvironmentObject var skinPreference: SkinPreference
    
    private var lightColor: Color {
        Color(skinPreference.skin.lightColor)
    }
    private var darkColor: Color {
        Color(skinPreference.skin.darkColor)
    }
    
    @AppStorage("isSoundOn") private var isSoundOn = true
    @AppStorage("isVibrationOn") private var isVibrationOn = true
    @AppStorage("isShakeRollOn") private var isShakeRollOn = true
    @AppStorage("diceSizeModifier") private var diceSizeModifier: Double = 1.0
    
    var body: some View {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    SkinCarousel()
                    optionsSection
                        .padding(.horizontal)
                    creditsSection
                        .padding(.horizontal)
                    Spacer()
                }
                .padding(.top, 16)
            }
            .tint(darkColor)
            .background(darkColor)
            .preferredColorScheme(.dark)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color(skinPreference.skin.darkColor), for: .navigationBar)
    }
    
    var optionsSection: some View {
        VStack {
            diceSizeSlider
            toggle(isOn: $isSoundOn, title: "Sounds")
            toggle(isOn: $isVibrationOn, title: "Vibrations")
            toggle(isOn: $isShakeRollOn, title: "Shake to roll", isLast: true)
        }
        .padding(.vertical, 8)
        .background(lightColor)
        .cornerRadius(20)
        // Removed 'pro mode'
//        .overlay {
//            proOverlay
//        }
    }
    
    var proOverlay: some View {
        ZStack {
            darkColor.opacity(0.7)
            VStack(spacing: 20) {
                Image(systemName: "lock.square.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 44)
                Text("Unlock more features with\nthe Pro version.")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .shadow(color: darkColor, radius: 12)
                Button {
                    // Do the purchase
                } label: {
                    Text("Buy now")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(darkColor)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.white)
                        .cornerRadius(100)
                }
            }
            .shadow(color: darkColor, radius: 12)
        }
    }
    
    var creditsSection: some View {
        Text("Made with ♥ by Johnathan Reid")
            .fontWeight(.medium)
            .foregroundColor(lightColor)
    }
    
    var diceSizeSlider: some View {
        Group {
            VStack(spacing: 8) {
                Text("Dice size")
                    .fontWeight(.medium)
                    .foregroundColor(darkColor)
                Slider(value: $diceSizeModifier, in: 0.4...1.6, step: 0.2)
                    .padding(.horizontal)
            }
            .padding(.vertical, 4)
            Divider().overlay { darkColor }
        }
    }
    
    func toggle(isOn: Binding<Bool>, title: String, isLast: Bool = false) -> some View {
        Group {
            Toggle(isOn: isOn) {
                Text(title)
                    .fontWeight(.medium)
                    .foregroundColor(darkColor)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            if !isLast {
                Divider().overlay { darkColor }
            }
        }
    }
}

struct SettingsScene_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScene()
            .environmentObject(SkinPreference())
    }
}
