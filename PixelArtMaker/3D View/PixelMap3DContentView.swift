//
//  ImmersiveContent.swift
//  MyFirstVisionApp
//
//  Created by Takeshi Tanaka on 2023/06/24.
//

import SwiftUI
import RealityKit

struct PixelMap3DContentView: View {
    
    let cubeSize: Float
    
    @Environment(AppViewModel.self) private var viewModel
    
    var body: some View {
//        ZStack(alignment: .bottom) {
            RealityView { content in
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
//                origin.components.set(HoverEffectComponent())
//                origin.generateCollisionShapes(recursive: false)
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
                            model.components[HoverEffectComponent.self] = .init()
                            model.generateCollisionShapes(recursive: false)
                            let size: Float = cubeSize
                            let position = SIMD3<Float>(
                                size * Float(x) - Float(pixelMap.width / 2) * cubeSize + cubeSize / 2,// - size * Float(pixelMap.width) / 2, //タップ位置が中央となるように全体をシフト
                                size * Float(y) - Float(pixelMap.width / 2) * cubeSize + cubeSize / 2,// + size / 2 - (geoHeight - cubeSize * Float(pixelMap.height - 1)), //上からか！
                                0
                            )
                            model.setPosition(position, relativeTo: nil)
                            model.components[CollisionComponent.self] = CollisionComponent(shapes: [colbox], isStatic: true)
                            model.collision = CollisionComponent(shapes: [colbox], isStatic: true)
                            model.generateCollisionShapes(recursive: false)
                            content.add(model)
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
                
            } update: { content in
                // default sizeによらずいつも(width: 1306.0, height: 734.0, depth: 544.0)
//                print("### updated 3d size: \(proxy.size)")
            }
            .gesture(SpatialTapGesture().onEnded({ value in
                print("### tap \(value)")
            }))
//            .gesture(SpatialTapGesture().targetedToAnyEntity().onEnded({ value in
//                let value = value
//                print("# value : \(value)") //動かないなんで。
//            }))
//            Text("Heart")
//                .font(.system(size: 120))
//                .padding(.init(top: 8, leading: 20, bottom: 8, trailing: 20))
//                .foregroundColor(.primary)
//                .background(content: {
//                    RoundedRectangle(cornerRadius: 12)
//                        .fill(Color.gray)
//                })
//                .offset(x: 0, y: 100)
//            .background {
//                ZStack {
//                    Rectangle()
//                        .fill(.red)
//                    VStack {
//                        Text("\(60) x \(90)")
//                            .font(.system(size: 120))
//                            .foregroundStyle(.green)
//                        Spacer()
//                        Text("---")
//                            .font(.largeTitle)
//                            .foregroundStyle(.blue)
//                    }
//                    .padding()
//                    
//                }
//                .border(Color.blue, width: 10)
//            }
//        }
        .onAppear {
            print("### Immersive Content did appear.")
        }
    }
    
}
