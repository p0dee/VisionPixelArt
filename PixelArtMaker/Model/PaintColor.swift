//
//  PaintColor.swift
//  PixelArtMaker
//
//  Created by Takeshi Tanaka on 2024/01/18.
//

import Foundation
import UIKit

struct PaintColor: Codable, Identifiable, Equatable {
    
    var id: String
    
    var uiColor: UIColor {
        guard let color = UIColor(named: id) else {
//            fatalError("There is no color named \"\(id)\".")
            return .white
        }
        return color
    }
    
}

extension PaintColor {
    
    static let clear: PaintColor = .init(id: "x")
    static let white: PaintColor = .init(id: "ga")
    
    static let presetColors: [PaintColor] = [
        .init(id: "ca"),
        .init(id: "cb"),
        .init(id: "cc"),
        .init(id: "cd"),
        .init(id: "ce"),
        .init(id: "cf"),
        .init(id: "cg"),
        .init(id: "ch"),
        .init(id: "ci"),
    ]
    
    static let presetGrays: [PaintColor] = [
        .init(id: "ga"),
        .init(id: "gb"),
        .init(id: "gc"),
        .init(id: "gd"),
        .init(id: "ge"),
    ]
    
}
