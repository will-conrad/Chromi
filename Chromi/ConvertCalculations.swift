//
//  ColorConversions.swift
//  Chromi
//
//  Created by Will Conrad on 1/11/23.
//

import Foundation
import UIKit

extension UIColor {
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
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    //Gets RGBA values
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        return (min(1, red), min(1, green), min(1, blue))
    }

    var hsl: (h: CGFloat, s: CGFloat, l: CGFloat) {
        var (h, s, b) = (CGFloat(), CGFloat(), CGFloat())
        getHue(&h, saturation: &s, brightness: &b, alpha: nil)
        
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
        return (h * 360.0, s * 100.0, l * 100.0)
    }
    var hsb:(hue: CGFloat, saturation: CGFloat, brightness: CGFloat) {
        var hue:CGFloat = 0
        var saturation:CGFloat = 0
        var brightness:CGFloat = 0
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil)
        return (min(hue, 1),min(saturation, 1),min(1, brightness))
    }
    var cmyk: (c: CGFloat, m: CGFloat, y: CGFloat, k: CGFloat) {
        let rgba = self.rgba
        
        let k = 1.0 - max(rgba.0, rgba.1, rgba.2)
        var c = (1.0 - rgba.0 - k) / (1.0 - k)
        var m = (1.0 - rgba.1 - k) / (1.0 - k)
        var y = (1.0 - rgba.2 - k) / (1.0 - k)
        
        if c.isNaN { c = 0.0 }
        if m.isNaN { m = 0.0 }
        if y.isNaN { y = 0.0 }
        
        return (c * 100.0, m * 100.0, y * 100.0, k * 100.0)
    }
    
    var hex: String {
        let components = self.rgba
        let r: CGFloat = components.0
        let g: CGFloat = components.1
        let b: CGFloat = components.2
        
        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        print(hexString)
        return hexString
    }
}



func colorToText(color: UIColor, type: ColorType) -> String {
    switch type {
    case .rgb:
        let r = Double(color.rgba.red * 255.0)
        let g = Double(color.rgba.green * 255.0)
        let b = Double(color.rgba.blue * 255.0)
        
        return "\(truncate(r)), \(truncate(g)), \(truncate(b))"
    case .hsl:
        let hsl = color.hsl
        let h = hsl.0
        let s = hsl.1
        let l = hsl.2
        return "\(truncate(h)), \(truncate(s)), \(truncate(l))"
        
    case .hsv: //Same as HSB
        let comps = color.hsb
        
        let h = Double(comps.0 * 360)
        let s = Double(comps.1 * 100)
        let v = Double(comps.2 * 100)
        
        return "\(truncate(h)), \(truncate(s)), \(truncate(v))"
    case .cmyk:
        let cmyk = color.cmyk
        let c = cmyk.0
        let m = cmyk.1
        let y = cmyk.2
        let k = cmyk.3
        return "\(truncate(c)), \(truncate(m)), \(truncate(y)), \(truncate(k))"
    case .hex:
        return color.hex
    }
}
    
func parseInputColor(color: String, type: ColorType) -> UIColor? {
    switch type {
    case .rgb:
        if let values = getSeparatedValues(numValues: 3, expectedValues: [255, 255, 255], color: color) {
            return UIColor(red: values[0], green: values[1], blue: values[2], alpha: 1)
        }
        return nil
        
    case .hsv://SAME AS HSB
        if let values = getSeparatedValues(numValues: 3, expectedValues: [360, 100, 100], color: color) {
            return UIColor(hue: values[0], saturation: values[1], brightness: values[2], alpha: 1)
        }
        return nil
        
    case .hsl:
        if let values = getSeparatedValues(numValues: 3, expectedValues: [360, 100, 100], color: color) {
            return UIColor(hue: values[0], saturation: values[1], lightness: values[2], alpha: 1)
        }
        return nil
        
    case .cmyk:
        if let values = getSeparatedValues(numValues: 4, expectedValues: [100, 100, 100, 100], color: color) {
            return UIColor(cmyk: values)
        }
        return nil
        
    case .hex:
        return UIColor(hexString: color)
    }
}

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
    
func truncate(_ x: Double) -> Double {
    return abs(ceil(x*100)/100)
}
