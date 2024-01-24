//
//  PixelMapCanvasView.swift
//  PixelArtMaker
//
//  Created by Takeshi Tanaka on 2023/07/08.
//

import SwiftUI


struct ArtCanvas: View {
    
    let data: PixelMapData
    
    var body: some View {
        Canvas { context, size in
            let cellWidth = size.width / CGFloat(data.width)
            let cellHeight = size.height / CGFloat(data.height)
            for i in 0..<data.height {
                for j in 0..<data.width {
                    let dot = data.mapData[j][i]
                    let fillColor: Color = {
                        if dot == .clear {
                            return .clear
                        } else {
                            return Color(uiColor: dot.uiColor)
                        }
                    }()
                    let fi = CGFloat(i)
                    let fj = CGFloat(j)
                    context.fill(
                        .init(
                            roundedRect: .init(x: fi*cellWidth, y: fj*cellHeight, width: cellWidth, height: cellHeight).insetBy(dx: 0.5, dy: 0.5),
                            cornerRadii: .init(topLeading: 2, bottomLeading: 2, bottomTrailing: 2, topTrailing: 2)
                        ),
                        with: .color(fillColor),
                        style: .init(eoFill: false, antialiased: true)
                    )
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
}
