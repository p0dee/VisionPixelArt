//
//  PixelArtMakerApp.swift
//  PixelArtMaker
//
//  Created by Takeshi Tanaka on 2023/06/18.
//

import SwiftData
import SwiftUI

@main
struct PixelArtMakerApp: App {    
    @State private var viewModel = AppViewModel()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([PixelMapData.self])
        let modelConfig = ModelConfiguration(schema: schema)
        let modelContainer = try! ModelContainer(for: PixelMapData.self, configurations: modelConfig)
        return modelContainer
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(viewModel)
        }
        .windowStyle(.plain)
        .modelContainer(sharedModelContainer)
        
        WindowGroup(id: "3d") {
            PixelMap3DContentView(cubeSize: 0.05)
                .environment(viewModel)
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 0.8, height: 0.8, depth: 0.1, in: .meters)
        
        ImmersiveSpace(id: "content") {
//            PixelMap3DContentView(cubeSize: 0.05)
//                .environment(viewModel)
            ImmersiveContent()
                .environment(viewModel)
        }
    }
}
