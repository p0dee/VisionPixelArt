//
//  PaletteView.swift
//  PixelArtMaker
//
//  Created by Takeshi Tanaka on 2023/06/18.
//

import SwiftUI

struct ColorPalette: View {
    
    private let colorElements: [PaintColor] = PaintColor.presetGrays + PaintColor.presetColors
    
    @Binding var selectedColor: PaintColor?
    
    var body: some View {
        HStack(alignment: .center, spacing: 16, content: {
            Spacer()
            ForEach(colorElements) { element in
                ColorCircle(color: Color(uiColor: element.uiColor), selected: selectedColor == element)
                    .onTapGesture {
                        selectedColor = element
                    }
                    .hoverEffect()
            }
            Spacer()
        })
        .fixedSize(horizontal: false, vertical: true)
        .padding(16)
//        .background {
//            Capsule()
//                .fill(Material.regularMaterial)
//        }
    }
    
    struct ColorCircle: View {
        let color: Color
        let selected: Bool
        
        var body: some View {
            ZStack {
                Circle()
                    .fill(color)
                    .frame(idealWidth: 60, idealHeight: 60)
                if selected {
                    Circle()
                        .fill(color.isDark ? .white.opacity(0.3) : .black.opacity(0.3))
                        .frame(width: 20, height: 20)
                        .animation(.spring)
                }
            }
        }
    }
    
    struct EraserCircle: View {
        var body: some View {
            Circle()
                .fill(Color.init(white: 0.05))
                .frame(idealWidth: 60, idealHeight: 60)
        }
    }
    
}
