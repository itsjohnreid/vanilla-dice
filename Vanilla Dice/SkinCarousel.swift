//
//  SkinCarousel.swift
//  Vanilla Dice
//
//  Created by John Reid on 26/5/2023.
//

import SwiftUI

struct SkinCarousel: View {
    var body: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
            VStack(spacing: 32) {
                HStack(spacing: 32) {
                    SkinTile(.vanilla)
                    SkinTile(.forest)
                    SkinTile(.fireball)
                }
                HStack(spacing: 32) {
                    SkinTile(.pastel)
                    SkinTile(.cosmic)
                    SkinTile(.arcane)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 16)
//        }
    }
}

struct SkinTile: View {
    @EnvironmentObject var skinPreference: SkinPreference
    let skin: Skin
    let size: CGSize = .init(width: 80, height: 140)
    let shadowSize: CGFloat = 10
    
    init(_ skin: Skin) {
        self.skin = skin
    }
    
    var body: some View {
        ZStack {
            shadow
            Button {
                self.skinPreference.skin = skin
                Settings.skin = skin.name.rawValue
            } label : {
                ZStack {
                    Color(skin.darkColor)
                    Color(skin.lightColor)
                        .cornerRadius(8)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 20)
                    VStack(spacing: 4) {
                        ForEach(skin.diceColors, id: \.self) { color in
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(color))
                                .frame(width: 24, height: 16)
                        }
                    }
                    VStack {
                        Spacer()
                        Text(skin.name.rawValue)
                            .font(.footnote)
                            .fontWeight(.medium)
                            .foregroundColor(Color(skin.lightColor))
                            .padding(2)
                    }
                }
                .frame(width: size.width, height: size.height)
                .cornerRadius(16)
            }
            .buttonStyle(SkinTileButtonStyle())
        }
    }
    
    private var shadow: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(.black)
            .opacity(0.2)
            .frame(width: size.width, height: size.height)
            .offset(x: shadowSize, y: shadowSize)
    }
}

extension SkinTile {
    private struct SkinTileButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .offset(x: configuration.isPressed ? 10 : 0, y: configuration.isPressed ? 10 : 0)
        }
    }
}

struct SkinCarousel_Previews: PreviewProvider {
    static var previews: some View {
        SkinCarousel()
    }
}
