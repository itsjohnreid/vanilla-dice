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
    
    @State private var isSoundOn = true
    @State private var isVibrationOn = true
    @State private var isTapRollOn = false
    @State private var isShakeRollOn = true
    @State private var isNumberSpinOn = true
    @State private var isD99On = false
    @State private var diceSizeModifier: Double = 1.0
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 32) {
                Spacer(minLength: 32)
                SkinCarousel()
                freeSection
                    .padding(.horizontal)
                proSection
                    .padding(.horizontal)
                creditsSection
                    .padding(.horizontal)
                Spacer()
            }
        }
        .tint(darkColor)
        .background(darkColor)
        .preferredColorScheme(.dark)
        .navigationTitle("Settings")
    }
    
    var freeSection: some View {
        VStack {
            toggle(isOn: $isSoundOn, title: "Sounds")
            toggle(isOn: $isVibrationOn, title: "Vibrations", isLast: true)
        }
        .padding(.vertical, 8)
        .background(lightColor)
        .cornerRadius(20)
    }
    
    var proSection: some View {
        VStack {
            diceSizeSlider
            toggle(isOn: $isTapRollOn, title: "Tap to roll")
            toggle(isOn: $isShakeRollOn, title: "Shake to roll")
            toggle(isOn: $isNumberSpinOn, title: "Numbers spin")
            toggle(isOn: $isD99On, title: "0-99 instead of 1-100", isLast: true)
        }
        .padding(.vertical, 8)
        .background(lightColor)
        .cornerRadius(20)
        .overlay {
            proOverlay
        }
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
                Slider(value: $diceSizeModifier, in: 0.7...1.4, step: 0.1)
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
    }
}
