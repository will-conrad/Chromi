//
//  ColorConversions.swift
//  Chromi
//
//  Created by Will Conrad on 1/11/23.
//

import Foundation
import UIKit

let delta: CGFloat = 6.0 / 29.0
let deltaQ = delta * delta * delta
let deltaSQ3 = delta * delta * 3

let d50: (X: CGFloat, Y: CGFloat, Z: CGFloat) = (95.0489, 100.000, 108.8840)
let d65: (X: CGFloat, Y: CGFloat, Z: CGFloat) = (96.4212, 100.000, 82.5188)

extension UIColor {
    // MARK: UIColor Convenience Inits
    
    /// Initializes a color from HSLA
    /// - parameter hue:
    /// - parameter saturation:
    /// - parameter lightness:
    convenience init(hue: CGFloat, saturation: CGFloat, lightness: CGFloat, alpha: CGFloat) {
        var newSaturation: CGFloat = 0.0
        
        let brightness = lightness + saturation * min(lightness, 1-lightness)
        
        if brightness == 0 {
            newSaturation = 0.0
        } else {
            newSaturation = 2 * (1 - lightness / brightness)
        }
        self.init(hue: hue, saturation: newSaturation, brightness: brightness, alpha: alpha)
    }
    
    /// Initializes a color from CMYK
    /// - parameter cmyk:
    convenience init(cmyk: [Double], alpha: CGFloat = 1.0) {
        let c = cmyk[0] / 100.0
        let m = cmyk[1] / 100.0
        let y = cmyk[2] / 100.0
        let k = cmyk[3] / 100.0

        let r = (1.0 - c) * (1.0 - k)
        let g = (1.0 - m) * (1.0 - k)
        let b = (1.0 - y) * (1.0 - k)

        self.init(red: r, green: g, blue: b, alpha: alpha)
    }

    /// Initializes a color from a hexadecimal integer in the RGB format (RRGGBB), e.g., 0xffff00.
    /// - parameter hex: The hexadecimal value of the color.
    /// - parameter alpha: The alpha value of the color.
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let str = hex.replacingOccurrences(of: "#", with: "")
        let hex = Int(str, radix: 16) ?? 000000
        let rgb = (
            r: CGFloat((hex >> 16) & 0xff) / 0xff,
            g: CGFloat((hex >> 08) & 0xff) / 0xff,
            b: CGFloat((hex >> 00) & 0xff) / 0xff
        )

        self.init(red: rgb.r, green: rgb.g, blue: rgb.b, alpha: alpha)
    }

    /// Initializes a color from CIE 1931 XYZ components.
    /// - parameter XYZ: The components used to initialize the color.
    /// - parameter alpha: The alpha value of the color.
    convenience init(xyz: [Double], alpha: CGFloat = 1.0) {
        let X = xyz[0]
        let Y = xyz[1]
        let Z = xyz[2]
        var r: Double = 0
        var g: Double = 0
        var b: Double = 0

        // sRGB matrix transformation
        // http://www.brucelindbloom.com/index.html?Eqn_RGB_XYZ_Matrix.html
        if GlobalColor.illuminant == .d65 {
             r =  (3.2404542 * X) - (1.5371385 * Y) - (0.4985314 * Z)
             g = (-0.9692660 * X) + (1.8760108 * Y) + (0.0415560 * Z)
             b =  (0.0556434 * X) - (0.2040259 * Y) + (1.0572252 * Z)
        } else { //d50
             r =  (3.1338561 * X) - (1.6168667 * Y) - (0.4906146 * Z)
             g = (-0.9787684 * X) + (1.9161415 * Y) + (0.0334540 * Z)
             b =  (0.0719453 * X) - (0.2289914 * Y) + (1.4052427 * Z)
        }
        
        // sRGB (D65) gamma correction - companding to get non-linear values
        let k: CGFloat = 1.0 / 2.4
        r = (r <= 0.00304) ? (12.92 * r) : (1.055 * pow(r, k) - 0.055)
        g = (g <= 0.00304) ? (12.92 * g) : (1.055 * pow(g, k) - 0.055)
        b = (b <= 0.00304) ? (12.92 * b) : (1.055 * pow(b, k) - 0.055)
        
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    /// Initializes a color from CIELAB components.
   /// - parameter lab: The components used to initialize the color.
   /// - parameter alpha: The alpha value of the color.
   convenience init(lab: [Double], alpha: CGFloat = 1.0) {
       func fn(_ t: CGFloat) -> CGFloat {
           if t > delta { return pow(t, 3.0) }
           return deltaSQ3 * (t - (4.0/29.0))
       }

       let ref = GlobalColor.illuminant == .d65 ? d65 : d50

       let L = (lab[0] + 16.0) / 116.0
       let a = L + (lab[1] / 500.0)
       let b = L - (lab[2] / 200.0)

       let X = fn(a) * ref.X
       let Y = fn(L) * ref.Y
       let Z = fn(b) * ref.Z

       self.init(xyz: [X, Y, Z], alpha: alpha)
   }
    
    // MARK: - UIColor Variables
    //Gets RGBA values
    var rgb: (red: CGFloat, green: CGFloat, blue: CGFloat) {
        var (r, g, b) = (CGFloat(), CGFloat(), CGFloat())
        getRed(&r, green: &g, blue: &b, alpha: nil)
        r = min(1, r)
        g = min(1, g)
        b = min(1, b)
        
        return (r, g, b)
    }

    var hsl: (h: CGFloat, s: CGFloat, l: CGFloat) {
        var (h, s, b) = self.hsb
        
        let l = ((2.0 - s) * b) / 2.0
        
        switch l {
        case 0.0, 1.0:
            s = 0.0
        case 0.0..<0.5:
            s = (s * b) / (l * 2.0)
        default:
            s = (s * b) / (2.0 - l * 2.0)
        }
        s = min(1, s)
        return (h, s, l)
    }
    var hsb:(hue: CGFloat, saturation: CGFloat, brightness: CGFloat) {
        var (h, s, b) = (CGFloat(), CGFloat(), CGFloat())
        getHue(&h, saturation: &s, brightness: &b, alpha: nil)
        h = min(1, h)
        s = min(1, s)
        b = min(1, b)
        
        return (h, s, b)
    }
    var cmyk: (c: CGFloat, m: CGFloat, y: CGFloat, k: CGFloat) {
        let (r, g, b) = self.rgb
        
        let k = 1.0 - max(r, g, b)
        let c = (1.0 - r - k) / (1.0 - k)
        let m = (1.0 - g - k) / (1.0 - k)
        let y = (1.0 - b - k) / (1.0 - k)

        return (c, m, y, k)
    }
    
    var hex: String {
        let (r, g, b) = self.rgb
        
        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        return hexString
    }
    /// The CIE 1931 XYZ components of the color.
    var xyz: (x: CGFloat, y: CGFloat, z: CGFloat) {
        var (r, g, b) = self.rgb
        
        // sRGB gamma correction - inverse companding to get linear values
        r = (r > 0.03928) ? pow((r + 0.055) / 1.055, 2.4) : (r / 12.92)
        g = (g > 0.03928) ? pow((g + 0.055) / 1.055, 2.4) : (g / 12.92)
        b = (b > 0.03928) ? pow((b + 0.055) / 1.055, 2.4) : (b / 12.92)

        var X: Double = 0
        var Y: Double = 0
        var Z: Double = 0
        
        // sRGB matrix transformation
        // http://www.brucelindbloom.com/index.html?Eqn_RGB_XYZ_Matrix.html
        if GlobalColor.illuminant == .d65 {
            X = (0.4124564 * r) + (0.3575761 * g) + (0.1804375 * b)
            Y = (0.2126729 * r) + (0.7151522 * g) + (0.0721750 * b)
            Z = (0.0193339 * r) + (0.1191920 * g) + (0.9503041 * b)
        } else { //d50
            X = (0.4360747 * r) + (0.3850649 * g) + (0.1430804 * b)
            Y = (0.2225045 * r) + (0.7168786 * g) + (0.0606169 * b)
            Z = (0.0139322 * r) + (0.0971045 * g) + (0.7141733 * b)
        }
        
        X = min(1, X)
        Y = min(1, Y)
        Z = min(1, Z)
        return (X, Y, Z)
    }
    /// UIColor to LAB.
    var lab: (l: CGFloat, a: CGFloat, b:CGFloat) {
        func fn(_ t: CGFloat) -> CGFloat {
            if t > deltaQ { return pow(t, (1/3)) }
            return (t / deltaSQ3) + (4.0 / 29.0)
        }

        let XYZ = self.xyz
        let ref = GlobalColor.illuminant == .d65 ? d65 : d50

        let X = fn(XYZ.0 / ref.X)
        let Y = fn(XYZ.1 / ref.Y)
        let Z = fn(XYZ.2 / ref.Z)

        let l = (116.0 * Y) - 16.0
        let a = 500.0 * (X - Y)
        let b = 200.0 * (Y - Z)
        print(a)
        return (l, a, b)
    }
}


// MARK: - UIColor -> String
func colorToText(color: UIColor, type: ColorType) -> String {
    switch type {
    case .rgb:
        let (r, g, b) = color.rgb
        if GlobalColor.useDecimals {
            return "\(truncate(r)), \(truncate(g)), \(truncate(b))"
        } else {
            return "\(truncate(r * 255)), \(truncate(g * 255)), \(truncate(b * 255))"
        }
        
    case .hsl:
        let (h, s, l) = color.hsl
        if GlobalColor.useDecimals {
            return "\(truncate(h)), \(truncate(s)), \(truncate(l))"
        } else {
            return "\(truncate(h * 360)), \(truncate(s * 100)), \(truncate(l * 100))"
        }
        
    case .hsv: //Same as HSB
        let (h, s, b) = color.hsb
        if GlobalColor.useDecimals {
            return "\(truncate(h)), \(truncate(s)), \(truncate(b))"
        } else {
            return "\(truncate(h * 360)), \(truncate(s * 100)), \(truncate(b * 100))"
        }
        
    case .cmyk:
        let (c, m, y, k) = color.cmyk
        if GlobalColor.useDecimals {
            return "\(truncate(c)), \(truncate(m)), \(truncate(y)), \(truncate(k))"
        } else {
            return "\(truncate(c * 100)), \(truncate(m * 100)), \(truncate(y * 100)), \(truncate(k * 100))"
        }
        
    case .hex:
        return color.hex
    case .ciexyz:
        let (x, y, z) = color.xyz
        if GlobalColor.useDecimals {
            return "\(truncate(x)), \(truncate(y)), \(truncate(z))"
        } else {
            return "\(truncate(x * 100)), \(truncate(y * 100)), \(truncate(z * 100))"
        }
    case .cielab:
        let (l, a, b) = color.lab
        if GlobalColor.useDecimals {
            return "\(truncate(l)), \(truncate(a)), \(truncate(b))"
        } else {
            return "\(truncate(l * 100)), \(truncate(a * 128)), \(truncate(b * 128))"
        }
    }
}

// MARK: String -> UIColor
func parseInputColor(color: String, type: ColorType) -> UIColor? {
    switch type {
    case .rgb:
        if let values = getSeparatedValues(
            numValues: 3,
            expectedValues: GlobalColor.useDecimals ? [1, 1, 1] : [255, 255, 255],
            color: color)
        {
            return UIColor(red: values[0], green: values[1], blue: values[2], alpha: 1)
        }
        return nil
        
    case .hsv://SAME AS HSB
        if let values = getSeparatedValues(
            numValues: 3,
            expectedValues: GlobalColor.useDecimals ? [360, 1, 1] : [360, 100, 100],
            color: color)
        {
            return UIColor(hue: values[0], saturation: values[1], brightness: values[2], alpha: 1)
        }
        return nil
        
    case .hsl:
        if let values = getSeparatedValues(
            numValues: 3,
            expectedValues: GlobalColor.useDecimals ? [1, 1, 1] : [360, 100, 100],
            color: color)
        {
            return UIColor(hue: values[0], saturation: values[1], lightness: values[2], alpha: 1)
        }
        return nil
        
    case .cmyk:
        if let values = getSeparatedValues(
            numValues: 4,
            expectedValues: GlobalColor.useDecimals ? [1, 1, 1, 1] : [100, 100, 100, 100],
            color: color)
        {
            return UIColor(cmyk: values)
        }
        return nil
        
    case .hex:
        return color.count <= 7 ? UIColor(hex: color) : nil
    case .ciexyz:
        if let values = getSeparatedValues(
            numValues: 3,
            expectedValues: GlobalColor.useDecimals ? [1, 1, 1] : [100, 100, 100],
            color: color)
        {
            print(values)
            return UIColor(xyz: values)
        }
        return nil
    case .cielab:
        if let values = getSeparatedValues(
            numValues: 3,
            expectedValues: GlobalColor.useDecimals ? [1, 1, 1] : [100, 127, 127],
            color: color)
        {
            return UIColor(lab: values)
        }
        return nil
    }
}
// MARK: Helpers
func getSeparatedValues(numValues num: Int, expectedValues: [Double], color: String) -> [Double]? {
    var valueArr: [Double] = []
    if color.contains(", ") {
        let delimiter = ", "
        let values = color.components(separatedBy: delimiter)
        if values.count == num {
            for i in 0...num - 1 {
                if let value = Double(values[i]) {
                    if value <= expectedValues[i] {
                        valueArr.append(value / expectedValues[i])
                    } else {
                        return nil
                    }
                } else {
                    return nil
                }
            }
        } else {
            return nil
        }
    } else {
        let delimiter = " "
        let values = color.components(separatedBy: delimiter)
        if values.count == num {
            for i in 0...num-1 {
                if let value = Double(values[i]) {
                    if value <= expectedValues[i] {
                        valueArr.append(value / expectedValues[i])
                    } else {
                        return nil
                    }
                } else {
                    return nil
                }
            }
        } else { return nil }
    }
    return valueArr
}

extension Decimal {
    var doubleValue:Double {
        return NSDecimalNumber(decimal:self).doubleValue
    }
}
func truncate(_ x: Double) -> Double {
    let negative = x<0
    let decimals = 3
    let n = pow(10.0, decimals).doubleValue
    let trunc = abs(ceil(x * n)/n)
    return negative ? -1 * trunc : trunc
}
