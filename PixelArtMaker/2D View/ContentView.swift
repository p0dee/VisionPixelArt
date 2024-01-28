//
//  ContentView.swift
//  PixelArtMaker
//
//  Created by Takeshi Tanaka on 2023/06/21.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationStack {
            TabView {
                ArtCollectionView()
                    .tabItem { 
                        Label("Works", systemImage: "square.grid.2x2.fill")
                    }
                DeletedArtCollectionView()
                    .tabItem {
                        Label("Deleted", systemImage: "trash.fill")
                    }
            }
        }
    }
    
}
