//
//  SwiftUIExtensions.swift
//  PixelArtMaker
//
//  Created by Takeshi Tanaka on 2024/01/18.
//

import SwiftUI

extension Color {
    
    var isDark: Bool {
        guard let cgColor else { return false }
        let uiColor = UIColor(cgColor: cgColor)
        var b: CGFloat = 0
        uiColor.getHue(nil, saturation: nil, brightness: &b, alpha: nil)
        return b < 0.2
    }
    
}
