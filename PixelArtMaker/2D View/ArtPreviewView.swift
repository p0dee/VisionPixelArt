//
//  ArtBoardPreview.swift
//  PixelArtMaker
//
//  Created by Takeshi Tanaka on 2023/07/05.
//

import SwiftUI

struct ArtPreviewView: View {
    
    @Binding var presentedArtBoard: PixelMapData?
    @State var presentingArtBoard: PixelMapData?
    
    @Environment(\.openWindow) private var openWindow
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
        
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                if let presentingArtBoard {
                    ArtCanvas(data: presentingArtBoard)
                        .frame(width: 200, height: 200, alignment: .center)
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        presentedArtBoard = nil
                    } label: {
                        Text("Close")
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        presentedArtBoard = nil
                        openWindow(id: "3d")
                    } label: {
                        Text("Volumetricに表示")
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        presentedArtBoard = nil
                        Task {
                            await openImmersiveSpace(id: "content")
                        }
                    } label: {
                        Text("Immersive Spaceに表示")
                    }
                }
            })
            .onAppear {
                presentingArtBoard = presentedArtBoard
            }
        }
    }
    
}
