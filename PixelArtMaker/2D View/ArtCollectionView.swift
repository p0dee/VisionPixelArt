//
//  ArtHistoryView.swift
//  PixelArtMaker
//
//  Created by Takeshi Tanaka on 2023/06/21.
//

import SwiftData
import SwiftUI

struct ArtCollectionView: View {
    
    @Environment(AppViewModel.self) private var viewModel
    @Environment(\.modelContext) private var modelContext
    
    @Query(filter: #Predicate<PixelMapData> { data in
        return data.isDeleted == nil || data.isDeleted == false
    }) private var records: [PixelMapData]
    
    @State private var isEditorPresented: Bool = false
    @State private var previewingPixelMap: PixelMapData? {
        didSet {
            viewModel.previewingPixelMap = previewingPixelMap
        }
    }
        
    private let cellWidth: CGFloat = 250
    private let itemSpacing: CGFloat = 60
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(.horizontal) {
                LazyHGrid(rows: [GridItem(.fixed(cellWidth))], spacing: itemSpacing, content: {
                    Spacer()
                        .frame(idealWidth: max((proxy.size.width - cellWidth) / 2 - itemSpacing, 0))
                    
                    Button {
                        isEditorPresented = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 100))
                            .imageScale(.large)
                    }
                    .buttonStyle(AddButtonStyle(size: cellWidth))

                    ForEach(records, id: \.id) { element in
                        Button {
                            previewingPixelMap = element
                        } label: {
                            ArtCanvas(data: element)
                        }
                        .buttonStyle(PixelArtButtonStyle(size: cellWidth))
                    }
                    
                    Spacer()
                        .frame(idealWidth: max((proxy.size.width - cellWidth) / 2 - itemSpacing, 0))
                })
                .padding(.init(top: 0, leading: 0, bottom: 60, trailing: 0))
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Pixel Land")
        .sheet(item: $previewingPixelMap) { artboard in
            ArtPreviewView(presentedArtBoard: $previewingPixelMap)
                .environment(viewModel)
        }
        .fullScreenCover(isPresented: $isEditorPresented) {
            ArtEditorContainerView(isPresenting: $isEditorPresented)
        }
        
    }
    
    struct AddButtonStyle: ButtonStyle {
        let size: CGFloat
        
        private let cornerRadius: CGFloat = 16
        private let lineWidth: CGFloat = 10
        
        func makeBody(configuration: Configuration) -> some View {
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(lineWidth: lineWidth)
                    .frame(width: size - lineWidth, height: size - lineWidth)
                configuration.label
                    
            }
            .frame(width: size, height: size)
            .foregroundStyle(.tertiary)
            .contentShape(RoundedRectangle(cornerRadius: cornerRadius))
            .hoverEffect()
        }
    }

    struct PixelArtButtonStyle: ButtonStyle {
        let size: CGFloat
        
        private let paddingWidth: CGFloat = 25
        private let cornerRadius: CGFloat = 16
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding(.init(paddingWidth))
                .frame(width: size, height: size)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(Material.ultraThin)
                )
                .hoverEffect()
        }
    }
    
}
