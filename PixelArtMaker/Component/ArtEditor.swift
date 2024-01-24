//
//  ArtBoardView.swift
//  PixelArtMaker
//
//  Created by Takeshi Tanaka on 2023/06/18.
//

import SwiftData
import SwiftUI

struct ArtEditor: View {
    
    struct Size {
        let width: Int
        let height: Int
        
        var aspectRatio: CGFloat {
            CGFloat(width) / CGFloat(height)
        }
    }
    
    private let boardSize: Size
    private var artUpdatedCallback: (([[PaintColor]]) -> Void)?
    
    @Binding var selectedColor: PaintColor?
    
    @State var pixelMapData: [[PaintColor]] {
        didSet {
            artUpdatedCallback?(pixelMapData)
        }
    }
    @State private var cursorPosition: CGPoint?
    
    init(boardSize: Size, selectedColor: Binding<PaintColor?>) {
        self.boardSize = boardSize
        _selectedColor = selectedColor
        
        let initialBoard = (0..<boardSize.height).map({ y in
            (0..<boardSize.width).map { x in
                PaintColor.clear
            }
        })
        self.pixelMapData = initialBoard
    }
    
    var body: some View {
        GeometryReader3D(content: { proxy in
            ZStack {
                VStack(spacing: 3, content: {
                    ForEach(0..<boardSize.height, id: \.self) { y in
                        HStack(spacing: 3, content: {
                            ForEach(0..<boardSize.width, id: \.self) { x in
                                Pixel(color: pixelColor(forX: x, y: y))
                                    .onTapGesture {
                                        guard let selectedColor else {
                                            pixelMapData[y][x] = .white
                                            return
                                        }
                                        let oldColor = pixelMapData[y][x]
                                        if oldColor == selectedColor {
                                            // 消しゴム
                                            pixelMapData[y][x] = .clear
                                        } else {
                                            pixelMapData[y][x] = selectedColor
                                        }
                                        
                                    }
                            }
                        })
                    }
                })
                .gesture(
                    DragGesture()
                        .onChanged({ dragValue in
                            cursorPosition = .init(x: dragValue.location3D.x, y: dragValue.location3D.y)
                            let cellWidth = proxy.size.width / CGFloat(boardSize.width)
                            let cellHeight = proxy.size.height / CGFloat(boardSize.height)
                            let x = Int(dragValue.location3D.x / cellWidth)
                            let y = Int(dragValue.location3D.y / cellHeight)
                            if x > 0, x < boardSize.width, y > 0, y < boardSize.height {
                                pixelMapData[y][x] = selectedColor ?? .clear
                            }
                        })
                        .onEnded({ _ in
                            cursorPosition = nil
                        })
                )
                if let cursorPosition {
                    Circle()
                        .frame(width: 30, height: 30, alignment: .center)
                        .foregroundColor(Color.white.opacity(0.5))
                        .position(x: cursorPosition.x, y: cursorPosition.y)
                }
            }
        })
        .aspectRatio(boardSize.aspectRatio, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
        
    private func pixelColor(forX x: Int, y: Int) -> Color? {
        if pixelMapData[y][x] == .clear {
            return nil
        }
        return Color(uiColor: pixelMapData[y][x].uiColor)
    }
    
    func didUpdateCallback(_ callback: @escaping ([[PaintColor]]) -> Void) -> Self {
        var ret = self
        ret.artUpdatedCallback = callback
        return ret
    }
    
    private struct Pixel: View {
        var color: Color?
        
        var body: some View {
            GeometryReader { context in
                RoundedRectangle(cornerRadius: 2)
                    .fill(color ?? Color.white.opacity(0.2))
                    .aspectRatio(1, contentMode: .fit)
                    .hoverEffect()
            }
        }
    }
    
}
