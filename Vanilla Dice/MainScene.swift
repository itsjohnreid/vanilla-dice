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
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
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
                skScene.trayDisplayDelegate = self
            }
        }
        .background(darkColor)
        .preferredColorScheme(.dark)
    }
    
    private var buttonOverlay: some View {
        VStack(spacing: 0) {
            Spacer()
            HStack(alignment: .bottom) {
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
    
    private var wipeOverlay: some View {
        Rectangle()
            .frame(width: size.width, height: size.height)
            .foregroundColor(darkColor)
            .opacity(wipeOpacity)
            .ignoresSafeArea()
    }
    
    private var dicePalette: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 4) {
                    ForEach(DieType.allCases) { dieType in
                        addDieButton(dieType: dieType)
                    }
                }
                .padding(.horizontal, 36)
                .padding(.top, 12)
                .padding(.bottom, 16)
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
                .shadow(radius: 6)
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
