//
//  Enumerations.swift
//  Chromi
//
//  Created by Will Conrad on 1/11/23.
//

import Foundation

enum ColorType: String, CaseIterable {
    case rgb = "rgb"
    case hsl = "hsl"
    case hsv = "hsv"
    case cmyk = "cmyk"
    case hex = "hex"
    case ciexyz = "ciexyz"
    case cielab = "cielab"
}
enum ColorScheme: String, CaseIterable {
    case complementary = "Complementary"
    case splitComplementary = "Split Complementary"
    case square = "Square"
    case tetradic = "Tetradic"
    case triadic = "Triadic"
    case analogous = "Analogous"
}
enum Illuminant: String {
    case d50 = "d50"
    case d65 = "d65"
}
