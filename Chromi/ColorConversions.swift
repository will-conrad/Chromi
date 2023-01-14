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
        precondition(0...1 ~= hue &&
                     0...1 ~= saturation &&
                     0...1 ~= lightness &&
                     0...1 ~= alpha, "input range is out of range 0...1")
        
        //From HSL TO HSB ---------
        var newSaturation: CGFloat = 0.0
        
        let brightness = lightness + saturation * min(lightness, 1-lightness)
        
        if brightness == 0 { newSaturation = 0.0 }
        else {
            newSaturation = 2 * (1 - lightness / brightness)
        }
        //---------
        
        self.init(hue: hue, saturation: newSaturation, brightness: brightness, alpha: alpha)
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
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue, alpha)
    }
    
    var hsba:(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var hue:CGFloat = 0
        var saturation:CGFloat = 0
        var brightness:CGFloat = 0
        var alpha:CGFloat = 0
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha){
            return (min(hue, 1),min(saturation, 1),min(1, brightness),min(1, alpha))
        }
        return (0,0,0,0)
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
        return (h * 360.0, s * 100.0, l * 100.0)
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
        print(color.rgba.red * 255.0)
        let r = Double(color.rgba.red * 255.0)
        let g = Double(color.rgba.green * 255.0)
        let b = Double(color.rgba.blue * 255.0)
        
        return "\(abs(ceil(r*100)/100)), \(abs(ceil(g*100)/100)), \(abs(ceil(b*100)/100))"
    case .hsl:
        let hsl = color.hsl
        return "\(abs(ceil(hsl.0*100)/100)), \(abs(ceil(hsl.1*100)/100)), \(abs(ceil(hsl.2*100)/100))"
        
    case .hsv: //Same as HSB
        let comps = color.hsba
        
        let h = Double(comps.0 * 360)
        let s = Double(comps.1 * 100)
        let v = Double(comps.2 * 100)
        return "\(abs(ceil(h*100)/100)), \(abs(ceil(s*100)/100)), \(abs(ceil(v*100)/100))"
    case .cmyk:
        let cmyk = color.cmyk
        return "\(abs(ceil(cmyk.0*100)/100)), \(abs(ceil(cmyk.1*100)/100)), \(abs(ceil(cmyk.2*100)/100)), \(abs(ceil(cmyk.3*100)/100))"
    case .hex:
        return color.hex
    }
}
    
func parseInputColor(color: String, type: ColorType) -> UIColor? {
    switch type {
    case .rgb:
        if color.contains(", ") {
            let delimiter = ", "
            let values = color.components(separatedBy: delimiter)
            
            if values.count == 3 {
                if let r = Double(values[0]), let g = Double(values[1]), let b = Double(values[2]) {
                    if r <= 255 && g <= 255 && b <= 255 {
                        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
                    }
                    return nil
                }
                return nil
            }
            return nil
        } else {
            let delimiter = " "
            let values = color.components(separatedBy: delimiter)
            if values.count == 3 {
                if let r = Double(values[0]), let g = Double(values[1]), let b = Double(values[2]) {
                    return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
                }
                return nil
            }
            return nil
        }
    case .hsv://SAME AS HSB
        if color.contains(", ") {
            let delimiter = ", "
            let values = color.components(separatedBy: delimiter)
            if values.count == 3 {
                print(values[0])
                print(values[1])
                print(values[2])
                if let h = Double(values[0]), let s = Double(values[1]), let v = Double(values[2]) {
                    if h <= 360 && s <= 100 && v <= 100 {
                        return UIColor(hue: h/360, saturation: s/100, brightness: v/100, alpha: 1)
                    }
                    return nil
                }
                return nil
            }
            return nil
        } else {
            let delimiter = " "
            let values = color.components(separatedBy: delimiter)
            if values.count == 3 {
                if let h = Double(values[0]), let s = Double(values[1]), let v = Double(values[2]) {
                    if h <= 360 && s <= 100 && v <= 100 {
                        return UIColor(hue: h/360, saturation: s/100, brightness: v/100, alpha: 1)
                    }
                    return nil
                }
            }
            return nil
        }
    case .hex:
        return UIColor(hexString: color)
    default:
        return nil
    }
}
    

