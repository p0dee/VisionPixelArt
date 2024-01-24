//
//  ModelEntity+Paint.swift
//  KamickeyPainter
//
//  Created by Takeshi Tanaka on 2023/02/11.
//

import RealityKit
import UIKit

extension ModelEntity {
    
    func paint(with color: PaintColor, commitsEffect: Bool) {
        if let colorComp = components[ModelColorComponent.self], colorComp.color == color {
            //すでに同色で塗られていた場合はスキップ
            return
        }
        var material = PhysicallyBasedMaterial()
        material.metallic = .init(floatLiteral: 0.0)
        material.roughness = .init(floatLiteral: 0.05)
        material.baseColor = .init(tint: color.uiColor, texture: nil)
        model?.materials = [material]
        components[ModelColorComponent.self] = .init(color: color)
        if commitsEffect {
            commitPaintEffect(for: self)
        }
    }
    
    private func commitPaintEffect(for model: ModelEntity) {
//        let haptic = UIImpactFeedbackGenerator(style: .light)
//        haptic.prepare()
//        haptic.impactOccurred(intensity: 1.0)
        
        //パン操作で塗ると描画が遅くなるのでいったん抑制
//        var transform = Transform.identity
//        let scale: Float = 0.85
//        transform.scale = .init(scale, scale, scale)
//        model.move(to: transform, relativeTo: model, duration: 0.1)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            let reversedScale: Float = 1 / model.transform.scale.x
//            transform.scale = .init(reversedScale, reversedScale, reversedScale)
//            model.move(to: transform, relativeTo: model, duration: 0.1)
//        }
    }
    
}
