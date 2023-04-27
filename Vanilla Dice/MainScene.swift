//
//  MainScene.swift
//  Vanilla Dice
//
//  Created by John Reid on 17/4/2023.
//

import SpriteKit
import SwiftUI

struct MainScene: View {
    private let trayHeight: CGFloat = 68
    private let skScene = DiceTraySKScene(size: CGSize(width: 100, height: 100))
    private var colorSkin = ColorSkin.vanilla
    private var lightColor: Color { Color(colorSkin.fillColor) }
    private var darkColor: Color { Color(colorSkin.borderColor) }
    
    @State private var dieNodes: [DieShapeNode] = []
    @State private var size: CGSize = CGSize(width: 100, height: 100)
    @State private var wipeOpacity: Double = 0
    @State private var rollTotal: Int = 0
    
    private var addDieButtonWidth: CGFloat {
        min(size.width / 16, 48)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                spriteView
                    .frame(width: geometry.size.width, height: geometry.size.height - trayHeight)
                dicePalette
            }
            .onAppear {
                updateSize(geometry.size)
                skScene.trayDisplayDelegate = self
            }
            .onChange(of: geometry.size) { newSize in
                updateSize(newSize)
                skScene.updateBounds()
                skScene.respawnDice()
            }
        }
        .background(darkColor)
        .preferredColorScheme(.dark)
    }
    
    private var spriteView: some View {
        SpriteView(
            scene: skScene,
            options: .ignoresSiblingOrder
        )
        .cornerRadius(32)
        .overlay {
            buttonOverlay
        }
        .overlay {
            wipeOverlay
        }
    }
    
    private var buttonOverlay: some View {
        VStack(spacing: 0) {
            Spacer()
            HStack(alignment: .bottom) {
                settingsButton
                Spacer()
                rollTotalView
                Spacer()
                refreshButton
            }
            .padding(8)
        }
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
                .background(lightColor.opacity(0.5))
                .clipShape(Circle())
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
                .background(lightColor.opacity(0.5))
                .clipShape(Circle())
        }
    }
    
    private var rollTotalView: some View {
        Text(String(rollTotal))
            .font(.body)
            .fontWeight(.semibold)
            .foregroundColor(darkColor)
            .padding(8)
            .background(lightColor.opacity(0.5))
            .cornerRadius(32)
    }
    
    private var wipeOverlay: some View {
        Rectangle()
            .frame(width: size.width, height: size.height)
            .foregroundColor(darkColor)
            .opacity(wipeOpacity)
            .ignoresSafeArea()
    }
    
    private var dicePalette: some View {
        HStack(alignment: .center, spacing: 4) {
            ForEach(DieType.allCases) { dieType in
                addDieButton(dieType: dieType)
            }
        }
        .padding(.top, 12)
        .padding(.bottom, 16)
        .id("hStack")
    }
    
    private func addDieButton(dieType: DieType) -> some View {
        Button {
            VibrationManager.shared.vibrate()
            skScene.addDie(dieType)
        } label: {
            Circle()
                .foregroundColor(lightColor)
                .frame(width: addDieButtonWidth, height: addDieButtonWidth)
//                .shadow(radius: 1)
                .overlay {
                    Text(dieType.name)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(darkColor)
                        .fixedSize()
                }
        }
        .overlay(alignment: .bottom) {
            if dieNodes.contains { $0.dieType == dieType } {
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundColor(darkColor)
                    .overlay {
                        Text("\(dieNodes.filter { $0.dieType == dieType }.count)")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundColor(lightColor)
                            .fixedSize()
                    }
                    .offset(y: 12)
            }
        }
    }
    
    private func updateSize(_ newSize: CGSize) {
        size = CGSize(width: newSize.width * 2, height: (newSize.height - trayHeight) * 2)
        skScene.size = size
    }
}

extension MainScene: TrayDisplayDelegate {
    func displayTotal(value: Int) {
        rollTotal = value
    }
    
    func dieNodesUpdated(dieNodes: [DieShapeNode]) {
        self.dieNodes = dieNodes
    }
}

struct MainScene_Previews: PreviewProvider {
    static var previews: some View {
        MainScene()
    }
}
