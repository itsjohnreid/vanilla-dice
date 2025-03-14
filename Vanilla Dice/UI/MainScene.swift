//
//  MainScene.swift
//  Vanilla Dice
//
//  Created by John Reid on 17/4/2023.
//

import SpriteKit
import SwiftUI

struct MainScene: View {
    @EnvironmentObject var skinPreference: SkinPreference
    private let trayHeight: CGFloat = 68
    private var lightColor: Color { Color(skinPreference.skin.lightColor) }
    private var darkColor: Color { Color(skinPreference.skin.darkColor) }
    
    @StateObject var viewModel = ViewModel()
    
    @State private var dieNodes: [DieShapeNode] = []
    @State private var size: CGSize = CGSize(width: 100, height: 100)
    @State private var tutorialOpacity: Double = 1
    @State private var wipeOpacity: Double = 0
    @State private var rollTotal: Int = 0
    @State private var hasShaken = false
    
    private var addDieButtonWidth: CGFloat {
        min(size.width / 16, 48)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                spriteView
                    .frame(width: abs(geometry.size.width), height: abs(geometry.size.height - trayHeight))
                dicePalette
            }
            .onAppear {
                updateSize(geometry.size)
                viewModel.skScene.trayDisplayDelegate = self
            }
            .onChange(of: geometry.size) { newSize in
                updateSize(newSize)
                viewModel.skScene.updateBounds()
                viewModel.skScene.respawnDice()
            }
        }
        .background(darkColor)
        .preferredColorScheme(.dark)
        .onChange(of: skinPreference.skin) { newValue in
            viewModel.skScene.refreshSkin()
        }
    }
    
    private var spriteView: some View {
        SpriteView(
            scene: viewModel.skScene,
            options: [.ignoresSiblingOrder, .shouldCullNonVisibleNodes]
        )
        .cornerRadius(32)
        .overlay {
            tutorialOverlay
        }
        .overlay {
            buttonOverlay
        }
        .overlay {
            wipeOverlay
        }
    }
    
    private var tutorialOverlay: some View {
        VStack {
            Text("Shake or swipe!")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(darkColor)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(lightColor.opacity(0.5))
                .cornerRadius(32)
                .offset(y: -size.height / 8)
        }
        .opacity(tutorialOpacity)
    }
    
    private var buttonOverlay: some View {
        VStack(spacing: 0) {
            Spacer()
            HStack(alignment: .bottom) {
                settingsButton
                Spacer()
                if hasShaken, dieNodes.count > 1 {
                    rollTotalView
                    Spacer()
                }
                refreshButton
            }
            .padding(8)
        }
    }
    
    private var settingsButton: some View {
        NavigationLink(destination: SettingsScene()) {
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
            viewModel.skScene.clearDice()
            hasShaken = false
            withAnimation {
                wipeOpacity = 0
            }
        } label: {
            Image(systemName: "trash")
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
        Text(String(rollTotal) + " total")
            .font(.body)
            .fontWeight(.semibold)
            .foregroundColor(darkColor)
            .padding(8)
            .background(lightColor.opacity(0.5))
            .cornerRadius(32)
    }
    
    private var wipeOverlay: some View {
        Rectangle()
            .frame(width: abs(size.width), height: abs(size.height))
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
            viewModel.skScene.addDie(dieType)
        } label: {
            Circle()
                .foregroundColor(lightColor)
                .frame(width: addDieButtonWidth, height: addDieButtonWidth)
                .overlay {
                    Text(dieType.name)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(darkColor)
                        .fixedSize()
                }
        }
        .overlay(alignment: .bottom) {
            if dieNodes.contains(where: { $0.dieType == dieType }) {
                Text("\(dieNodes.filter { $0.dieType == dieType }.count)")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(lightColor)
                    .fixedSize()
                    .padding(.horizontal, 5)
                    .padding(.vertical, 2)
                    .background {
                        darkColor
                    }
                    .cornerRadius(20)
                    .offset(y: 10)
            }
        }
    }
    
    private func updateSize(_ newSize: CGSize) {
        size = CGSize(width: newSize.width * 2, height: (newSize.height - trayHeight) * 2)
        viewModel.skScene.size = size
    }
}

extension MainScene: TrayDisplayDelegate {
    func displayTotal(value: Int) {
        rollTotal = value
    }
    
    func dieNodesUpdated(dieNodes: [DieShapeNode]) {
        self.dieNodes = dieNodes
    }
    
    func shook() {
        hasShaken = true
        if tutorialOpacity > 0 {
            withAnimation(.easeInOut(duration: 0.1)) {
                tutorialOpacity = 0
            }
        }
    }
}

struct MainScene_Previews: PreviewProvider {
    static var previews: some View {
        MainScene()
            .environmentObject(SkinPreference())
    }
}
