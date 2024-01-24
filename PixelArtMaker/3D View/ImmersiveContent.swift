//
//  ImmersiveContent.swift
//  PixelArtMaker
//
//  Created by Takeshi Tanaka on 2023/07/10.
//

import SwiftUI
import ARKit
import RealityKit


struct ImmersiveContent: View {
    
    let cubeSize: Float = 0.1
    
    private var anchorEntity: AnchorEntity = AnchorEntity(.plane(.vertical, classification: .wall,
                                                                 minimumBounds: [1, 1]))
    private let session = ARKitSession()
    private let sceneReconstruction = SceneReconstructionProvider()
    
    private let originModel: ModelEntity = {
        let cubeMesh = MeshResource.generateBox(size: 0.1, cornerRadius: 0.1 * 0.05)
        var material = SimpleMaterial()
        material.metallic = .init(floatLiteral: 0.0)
        material.roughness = .init(floatLiteral: 0.05)
        material.color = .init(tint: .red, texture: nil)
        let cubeModel = ModelEntity(mesh: cubeMesh, materials: [material])
        let colbox = ShapeResource.generateBox(size: .init(0.1, 0.1, 0.1))
        cubeModel.collision = .init(shapes: [colbox])
        var boxels: [[ModelEntity?]] = [[]]
        var maxY: Float = 0
        
        let origin = cubeModel.clone(recursive: true)
        origin.paint(with: .clear, commitsEffect: false)
        origin.position = .init()
        
        return origin
    }()
    
    @Environment(AppViewModel.self) private var viewModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            RealityView { content in
                do {
                    let anchor = anchorEntity
                    content.add(anchor)
                    
                    let contentAnchor = AnchorEntity()
                    anchor.addChild(contentAnchor)
                    
                    let cubeMesh = MeshResource.generateBox(size: cubeSize, cornerRadius: cubeSize * 0.05)
                    var material = SimpleMaterial()
                    material.metallic = .init(floatLiteral: 0.0)
                    material.roughness = .init(floatLiteral: 0.05)
                    material.color = .init(tint: .red, texture: nil)
                    let cubeModel = ModelEntity(mesh: cubeMesh, materials: [material])
                    let colbox = ShapeResource.generateBox(size: .init(cubeSize, cubeSize, cubeSize))
                    cubeModel.collision = .init(shapes: [colbox])
                    var boxels: [[ModelEntity?]] = [[]]
                    var maxY: Float = 0
                    
                    originModel.paint(with: .clear, commitsEffect: false)
                    originModel.position = .init()
                    originModel.components[HoverEffectComponent.self] = .init()
                    originModel.generateCollisionShapes(recursive: false)
                    content.add(originModel)
                    
                    return;
                    guard let pixelMap = viewModel.previewingPixelMap else { return }
                    for y in 0..<pixelMap.height {
                        var line: [ModelEntity?] = []
                        for x in 0..<pixelMap.width {
                            let invertedY = pixelMap.height - y - 1
                            if let color = pixelMap.color(atX: x, y: invertedY), color != .clear {
                                let model = cubeModel.clone(recursive: true)
                                model.paint(with: color, commitsEffect: false)
                                let modelClass = pixelMap.modelClass(atX: x, y: invertedY)!
                                let modelClassComp = ModelClassComponent(class: modelClass)
                                model.components[ModelClassComponent.self] = modelClassComp
                                model.components[BoxelCoordinateComponent.self] = .init(x: x, y: invertedY, z: 0)
                                model.components.set(HoverEffectComponent())
                                let size: Float = cubeSize
                                let position = SIMD3<Float>(
                                    size * Float(x) - Float(pixelMap.width / 2) * cubeSize,// - size * Float(pixelMap.width) / 2, //タップ位置が中央となるように全体をシフト
                                    0,
                                    size * Float(pixelMap.height) * 0.5 - size * Float(y)// + size / 2 - (geoHeight - cubeSize * Float(pixelMap.height - 1)), //上からか！
                                )
                                model.setPosition(position, relativeTo: nil)
                                anchor.addChild(model)
                                line.append(model)
                                maxY = max(maxY, position.y)
                            } else {
                                line.append(nil)
                            }
                        }
                        boxels.insert(line, at: 0)
                    }
                    func modelIfExists(atX x: Int, y: Int) -> ModelEntity? {
                        if x < 0 { return nil }
                        if y < 0 { return nil }
                        if y < boxels.count {
                            let line = boxels[y]
                            if x < line.count {
                                return line[x]
                            }
                        }
                        return nil
                    }
                    
                    //construct surrounding links
                    for y in 0..<boxels.count {
                        let line = boxels[y]
                        for x in 0..<line.count {
                            if let model = line[x] {
                                var result = SurroundingBoxelsComponent()
                                result.top = modelIfExists(atX: x, y: y - 1)
                                result.topRight = modelIfExists(atX: x + 1, y: y - 1)
                                result.right = modelIfExists(atX: x + 1, y: y)
                                result.bottomRight = modelIfExists(atX: x + 1, y: y + 1)
                                result.bottom = modelIfExists(atX: x, y: y + 1)
                                result.bottomLeft = modelIfExists(atX: x - 1, y: y + 1)
                                result.left = modelIfExists(atX: x - 1, y: y)
                                result.topLeft = modelIfExists(atX: x - 1, y: y - 1)
                                
                                model.components[SurroundingBoxelsComponent.self] = result
                            }
                        }
                    }
                }
            } update: { content in
                return
                do {
                    let anchor = AnchorEntity(.plane(.vertical, classification: .wall,
                                                     minimumBounds: [1, 1]))
                    content.add(anchor)
                    
                    let contentAnchor = AnchorEntity()
                    anchor.addChild(contentAnchor)
                    
                    let cubeMesh = MeshResource.generateBox(size: cubeSize, cornerRadius: cubeSize * 0.05)
                    var material = PhysicallyBasedMaterial()
                    material.metallic = .init(floatLiteral: 0.0)
                    material.roughness = .init(floatLiteral: 0.05)
                    material.baseColor = .init(tint: .red, texture: nil)
                    let cubeModel = ModelEntity(mesh: cubeMesh, materials: [material])
                    let colbox = ShapeResource.generateBox(size: .init(cubeSize, cubeSize, cubeSize))
                    cubeModel.collision = .init(shapes: [colbox])
                    var boxels: [[ModelEntity?]] = [[]]
                    var maxY: Float = 0
                    
    //                let origin = cubeModel.clone(recursive: true)
    //                origin.paint(with: .grayscale0_0, commitsEffect: false)
    //                origin.position = .init()
    //                content.add(origin)
                    
                    guard let pixelMap = viewModel.previewingPixelMap else { return }
                    for y in 0..<pixelMap.height {
                        var line: [ModelEntity?] = []
                        for x in 0..<pixelMap.width {
                            let invertedY = pixelMap.height - y - 1
                            if let color = pixelMap.color(atX: x, y: invertedY), color != .clear {
                                let model = cubeModel.clone(recursive: true)
                                model.paint(with: color, commitsEffect: false)
                                let modelClass = pixelMap.modelClass(atX: x, y: invertedY)!
                                let modelClassComp = ModelClassComponent(class: modelClass)
                                model.components[ModelClassComponent.self] = modelClassComp
                                model.components[BoxelCoordinateComponent.self] = .init(x: x, y: invertedY, z: 0)
                                let size: Float = cubeSize
                                let position = SIMD3<Float>(
                                    size * Float(x) - Float(pixelMap.width / 2) * cubeSize,// - size * Float(pixelMap.width) / 2, //タップ位置が中央となるように全体をシフト
                                    0,
                                    size * Float(pixelMap.height) * 0.5 - size * Float(y)// + size / 2 - (geoHeight - cubeSize * Float(pixelMap.height - 1)), //上からか！
                                )
                                model.setPosition(position, relativeTo: nil)
                                anchor.addChild(model)
                                line.append(model)
                                maxY = max(maxY, position.y)
                            } else {
                                line.append(nil)
                            }
                        }
                        boxels.insert(line, at: 0)
                    }
                    func modelIfExists(atX x: Int, y: Int) -> ModelEntity? {
                        if x < 0 { return nil }
                        if y < 0 { return nil }
                        if y < boxels.count {
                            let line = boxels[y]
                            if x < line.count {
                                return line[x]
                            }
                        }
                        return nil
                    }
                    
                    //construct surrounding links
                    for y in 0..<boxels.count {
                        let line = boxels[y]
                        for x in 0..<line.count {
                            if let model = line[x] {
                                var result = SurroundingBoxelsComponent()
                                result.top = modelIfExists(atX: x, y: y - 1)
                                result.topRight = modelIfExists(atX: x + 1, y: y - 1)
                                result.right = modelIfExists(atX: x + 1, y: y)
                                result.bottomRight = modelIfExists(atX: x + 1, y: y + 1)
                                result.bottom = modelIfExists(atX: x, y: y + 1)
                                result.bottomLeft = modelIfExists(atX: x - 1, y: y + 1)
                                result.left = modelIfExists(atX: x - 1, y: y)
                                result.topLeft = modelIfExists(atX: x - 1, y: y - 1)
                                
                                model.components[SurroundingBoxelsComponent.self] = result
                            }
                        }
                    }
                }
            }
            .gesture(
                DragGesture().targetedToAnyEntity().onEnded({ value in
                    originModel.position = value.convert(value.location3D, from: .local, to: anchorEntity.parent!)
                })
            )
            Text("Heart")
                .foregroundColor(.primary)
                .backgroundStyle(Material.regular)
        }
        
    }
    
    func runSession() async {
        do {
            try await session.run([sceneReconstruction])
        } catch {
            print("### Failed to start session: \(error)")
        }
    }
    
}
