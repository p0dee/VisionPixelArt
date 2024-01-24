//
//  PixelMap.swift
//  PixelArtMaker
//
//  Created by Takeshi Tanaka on 2023/07/07.
//

import Foundation
import SwiftData

@Model
class PixelMapData {    
    
    let createdAt: Date
    let title: String
    let width: Int
    let height: Int
    let mapData: [[PaintColor]]
    
    init(createdAt: Date, title: String, width: Int, height: Int, mapData: [[PaintColor]]) {
        self.createdAt = createdAt
        self.title = title
        self.width = width
        self.height = height
        self.mapData = mapData
    }
    
    private func stringnizedMap() -> String {
        let result = mapData.reduce("") { partialResult, colorArr in
            let arrStr = colorArr.reduce("") { partialResult, color in
                if partialResult.isEmpty {
                    return "\(color.id)"
                } else {
                    return "\(partialResult),\(color.id)"
                }
            }
            if partialResult.isEmpty {
                return "\(arrStr)"
            } else {
                return "\(partialResult),\(arrStr)"
            }
        }
        return result
    }
    
    var dictionaryRepresentation: [String : Any] {
        [
            "createdAt": createdAt,
            "title": title,
            "width": width,
            "height": height,
            "pixelMap": stringnizedMap()
        ]
    }
    
}

extension PixelMapData {
    
    static func create(with map: [[PaintColor]], title: String) -> PixelMapData {
        //check map validation
        guard let firstRowCount: Int = map.first?.count else {
            fatalError("map dosen't have any row.")
        }
        for i in 1..<map.count {
            if map[i].count != firstRowCount {
                fatalError("every row in a map must have same length.")
            }
        }
        let width = firstRowCount
        let height = map.count
        
        return PixelMapData(
            createdAt: Date(),
            title: title,
            width: width,
            height: height,
            mapData: map
        )
    }
    
}

extension PixelMapData: Identifiable {
    
    var id: Double {
        createdAt.timeIntervalSince1970
    }
    
}

extension PixelMapData: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
    }
    
}

extension PixelMapData {
    
    convenience init?(dictionary: [String : Any]) {
        guard let createdAt = dictionary["createdAt"] as? Date,
              let title = dictionary["title"] as? String,
              let width = dictionary["width"] as? Int,
              let height = dictionary["height"] as? Int,
              let pixelMapString = dictionary["pixelMap"] as? String else {
            return nil
        }
        
        self.init(
            createdAt: createdAt,
            title: title,
            width: width,
            height: height,
            mapData: PixelMapData.pixelMap(fromString: pixelMapString, width: width, height: height)
        )
    }
    
    private static func pixelMap(fromString string: String, width: Int, height: Int) -> [[PaintColor]] {
        let colorIDs = string.components(separatedBy: ",").compactMap { str in
            return str
        }
        let colors = colorIDs.compactMap { id in
            PaintColor(id: id)
        }
        guard colors.count == width * height else {
            fatalError("invalid pixel map data. string count must be equal to width * heigh.")
        }
        var result: [[PaintColor]] = []
        for i in 0..<height {
            let startIndex = i * width
            let endIndex = startIndex + width - 1
            let row = Array(colors[startIndex...endIndex])
            result.append(row)
        }
        return result
    }
    
}

extension PixelMapData {
    
    func colorID(atX x: Int, y: Int) -> String? {
        color(atX: x, y: y)?.id
    }
    
    func color(atX x: Int, y: Int) -> PaintColor? {
        guard x < width, y < height else {
            return nil
        }
        return mapData[y][x]
    }
//    
    func modelClass(atX x: Int, y: Int) -> ModelClassComponent.Class? {
        guard let colorID = colorID(atX: x, y: y) else { return nil }
//        let clazz = colorNameToModelClass(colorName)
//        let fixedFlag = fixedFlag(atX: x, y: y)
//        if fixedFlag, case .boxel = clazz {
//            return clazz!.paintDisabled()
//        }
        return .boxel(paintable: true, brightness: .normal)
    }
    
}
