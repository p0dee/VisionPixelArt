//
//  DeletedArtCollectionView.swift
//  PixelArtMaker
//
//  Created by Takeshi Tanaka on 2024/01/28.
//

import SwiftData
import SwiftUI

struct DeletedArtCollectionView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Query(filter: #Predicate<PixelMapData> { data in
        return data.isDeleted == true
    }) private var records: [PixelMapData]
        
    private let cellWidth: CGFloat = 250
    private let itemSpacing: CGFloat = 60
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(.horizontal) {
                LazyHGrid(rows: [GridItem(.fixed(cellWidth))], spacing: itemSpacing, content: {
                    Spacer()
                        .frame(idealWidth: max((proxy.size.width - cellWidth) / 2 - itemSpacing, 0))

                    ForEach(records, id: \.id) { element in
                        Button {
                            //TODO: display alert to recover selected data
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
        .navigationTitle("Deleted data")
        
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

