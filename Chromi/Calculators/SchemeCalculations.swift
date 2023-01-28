//
//  ColorSchemes.swift
//  Chromi
//
//  Created by Will Conrad on 1/12/23.
//

import Foundation
import UIKit

extension UIColor {
    var complementary: [UIColor] {
        return [self, self.withHueOffset(0.5)]
    }
    var splitComplementary: [UIColor] {
        let a = self.withHueOffset(150 / 360)
        let b = self.withHueOffset(210 / 360)
        return [self, a, b]
    }
    var square: [UIColor] {
        return [self, self.withHueOffset(0.25), self.withHueOffset(0.5), self.withHueOffset(0.75)]
    }
    var triadic: [UIColor] {
        return [self, self.withHueOffset(120 / 360), self.withHueOffset(240 / 360)]
    }
    var tetradic: [UIColor] {
        return [self, self.withHueOffset(60/360), self.withHueOffset(0.5), self.withHueOffset(240/360)]
    }
    var analagous: [UIColor] {
        return [self.withHueOffset(11 / 12), self, self.withHueOffset(1 / 12)]
    }

    func withHueOffset(_ offset: CGFloat) -> UIColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: fmod(h + offset, 1), saturation: s, brightness: b, alpha: a)
    }
}
