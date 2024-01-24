//
//  ArtMakerView.swift
//  PixelArtMaker
//
//  Created by Takeshi Tanaka on 2023/06/18.
//

import SwiftData
import SwiftUI

struct ArtEditorContainerView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    private let boardSize: ArtEditor.Size = .init(width: 16, height: 16)
    
    @Binding var isPresenting: Bool
    
    @State private var isDistructiveConfirmationPresented: Bool = false
    @State private var selectedColor: PaintColor?
    @State private var latestData: [[PaintColor]] = [[]]
    
    var body: some View {
        NavigationStack {
            ArtEditor(boardSize: boardSize, selectedColor: $selectedColor)
                .didUpdateCallback({ data in
                    self.latestData = data
                })
                .padding(.init(top: 0, leading: 0, bottom: 60, trailing: 0))
                .navigationBarBackButtonHidden()
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            isDistructiveConfirmationPresented = true
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            let title = "ArtBoard \(Date().description)"
                            let model = PixelMapData.create(with: latestData, title: title)
                            modelContext.insert(model)
                            isPresenting = false
                        }
                    }
                    ToolbarItem(placement: .bottomOrnament) {
                        ColorPalette(selectedColor: $selectedColor)
                    }
                })
                .alert(isPresented: $isDistructiveConfirmationPresented) {
                    Alert(title: Text("変更内容は破棄されます"),
                          primaryButton: .cancel(Text("戻る")),
                          secondaryButton: .destructive(
                            Text("破棄する"),
                            action: {
                                isPresenting = false
                            }
                          )
                    )
                }
        }
    }
    
}
