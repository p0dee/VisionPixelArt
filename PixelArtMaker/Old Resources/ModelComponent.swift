//
//  ModelComponent.swift
//  KamickeyPainter
//
//  Created by Takeshi Tanaka on 2023/02/11.
//

import RealityKit
import UIKit

struct ModelColorComponent: Component {
    
    var color: PaintColor
    
}

struct ModelClassComponent: Component {
            
    enum Class {
        enum Brightness {
            case dark, normal, bright
        }
        
        case boxel(paintable: Bool, brightness: Brightness)
        
        func paintDisabled() -> Class {
            if case .boxel(_, let brightness) = self {
                return .boxel(paintable: false, brightness: brightness)
            }
            return self
        }
    }
    
    var `class`: Class
    
}

struct BoxelCoordinateComponent: Component {
    
    var x: Int
    var y: Int
    var z: Int //always 0
    
}

struct SurroundingBoxelsComponent: Component {
    
    weak var top: ModelEntity?
    weak var topRight: ModelEntity?
    weak var right: ModelEntity?
    weak var bottomRight: ModelEntity?
    weak var bottom: ModelEntity?
    weak var bottomLeft: ModelEntity?
    weak var left: ModelEntity?
    weak var topLeft: ModelEntity?
    
    var crossSurroundings: [ModelEntity] {
        var result: [ModelEntity] = []
        result.safelyAppend(top)
        result.safelyAppend(right)
        result.safelyAppend(bottom)
        result.safelyAppend(left)
        return result
    }
    
    var squareSurroundings: [ModelEntity] {
        var result: [ModelEntity] = []
        result.safelyAppend(top)
        result.safelyAppend(topRight)
        result.safelyAppend(right)
        result.safelyAppend(bottomRight)
        result.safelyAppend(bottom)
        result.safelyAppend(bottomLeft)
        result.safelyAppend(left)
        result.safelyAppend(topLeft)
        return result
    }
    
    var diagonalSurroundings: [ModelEntity] {
        var result: [ModelEntity] = []
        result.safelyAppend(topRight)
        result.safelyAppend(bottomRight)
        result.safelyAppend(bottomLeft)
        result.safelyAppend(topLeft)
        return result
    }
    
}

private extension [ModelEntity] {
    
    mutating func safelyAppend(_ other: ModelEntity?) {
        guard let other else {
            return
        }
        self.append(other)
    }
    
}
