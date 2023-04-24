//
//  MainScene.swift
//  Vanilla Dice
//
//  Created by John Reid on 17/4/2023.
//

import SpriteKit
import SwiftUI

struct MainScene: View {
    private let trayHeight: CGFloat = 64
    private let skScene = DiceTraySKScene(size: CGSize(width: 100, height: 100))
    private var lightColor = Color(colorFromHex(hex: 0xfefae0))
    private var darkColor = Color(colorFromHex(hex: 0x9a581f))
    @State private var size: CGSize = CGSize(width: 100, height: 100)
    @State private var wipeOpacity: Double = 0
    @State private var rollTotal: Int = 0
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                SpriteView(
                    scene: skScene,
                    options: .ignoresSiblingOrder
                )
                .frame(width: geometry.size.width, height: geometry.size.height - trayHeight)
                .cornerRadius(32)
                .overlay {
                    buttonOverlay
                }
                .overlay {
                    wipeOverlay
                }
                dicePalette
            }
            .onAppear {
                size = CGSize(width: geometry.size.width * 2, height: (geometry.size.height - trayHeight) * 2)
                skScene.size = size
                skScene.totalDisplayDelegate = self
            }
        }
        .background(darkColor)
    }
    
    private var buttonOverlay: some View {
        VStack(spacing: 0) {
            Spacer()
            HStack {
                refreshButton
                Spacer()
                rollTotalView
                Spacer()
                settingsButton
            }
            .padding(8)
        }
    }
    
    private var refreshButton: some View {
        Button {
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            wipeOpacity = 1
            skScene.clearDice()
            withAnimation {
                wipeOpacity = 0
            }
        } label: {
            Image(systemName: "arrow.clockwise")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
                .foregroundColor(darkColor)
                .padding(8)
                .background(lightColor.opacity(0.7))
                .clipShape(Circle())
        }
    }
    
    private var rollTotalView: some View {
        Text(String(rollTotal))
            .fontWeight(.medium)
            .foregroundColor(darkColor)
            .padding(8)
            .background(lightColor.opacity(0.7))
            .cornerRadius(32)
    }
    
    private var settingsButton: some View {
        Button {
            // Open settings
        } label: {
            Image(systemName: "gearshape")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
                .foregroundColor(darkColor)
                .padding(8)
                .background(lightColor.opacity(0.7))
                .clipShape(Circle())
        }
    }
    
    private var wipeOverlay: some View {
        VStack {
            Rectangle()
                .frame(width: size.width, height: size.height)
                .foregroundColor(darkColor)
                .opacity(wipeOpacity)
            Spacer()
        }
    }
    
    private var dicePalette: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 4) {
                    ForEach(DieType.allCases) { dieType in
                        addDieButton(dieType: dieType)
                    }
                }
                .padding(.horizontal, 24)
                .id("hStack")
            }
            .onAppear {
                proxy.scrollTo("hStack", anchor: .center)
            }
        }
    }
    
    private func addDieButton(dieType: DieType) -> some View {
        Button {
            VibrationManager.shared.vibrate()
            skScene.addDie(dieType)
        } label: {
            Circle()
                .foregroundColor(lightColor)
                .frame(width: 48, height: 48)
                .overlay {
                    Text(dieType.name)
                        .fontWeight(.medium)
                        .foregroundColor(darkColor)
                }
        }
    }
}

extension MainScene: TotalDisplayDelegate {
    func displayTotal(value: Int) {
        rollTotal = value
    }
}

struct MainScene_Previews: PreviewProvider {
    static var previews: some View {
        MainScene()
    }
}
