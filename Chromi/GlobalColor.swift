//
//  GlobalColor.swift
//  Chromi
//
//  Created by Will Conrad on 1/12/23.
//

import Foundation
import UIKit

class GlobalColor {
    static var color = defaultColor
    static var colorNS: NSString {
        return self.color.hex as NSString
    }
    static let defaultColor = UIColor(hex: "#5865F2")
    static let defaultColorNS = defaultColor.hex as NSString
    
    
    static var inputType = defaultInputType
    static var inTypeNS: NSString {
        return self.inputType.rawValue as NSString
    }
    static let defaultInputType = ColorType.rgb
    static let defaultInputTypeNS = defaultInputType.rawValue as NSString
    
    
    static var outputType = defaultOutputType
    static var outTypeNS: NSString {
        return self.outputType.rawValue as NSString
    }
    static let defaultOutputType = ColorType.hex
    static let defaultOutputTypeNS = defaultOutputType.rawValue as NSString
    
    static var useDecimals = defaultDecimals
    static var useDecimalsNS: NSDictionary {
        return self.useDecimals as NSDictionary
    }
    static var defaultDecimals: [String:Bool] = [
        "rgb": false,
        "hsl": false,
        "hsv": false,
        "cmyk": false,
        "ciexyz": false,
        "cielab": false
    ]
    static var defaultDecimalsNS: NSDictionary = defaultDecimals as NSDictionary
    
    static var illuminant = Illuminant.d65
    
    let defaults = UserDefaults.standard
    
    //Pull defaults from UserDefaults
    init() {
        if let color = defaults.object(forKey: "color") as? String {
            GlobalColor.color = UIColor(hex: color)
        }
        if let inType = defaults.object(forKey: "inType") as? String {
            GlobalColor.inputType = ColorType(rawValue: inType) ?? GlobalColor.defaultInputType
        }
        if let outType = defaults.object(forKey: "outType") as? String {
            GlobalColor.outputType = ColorType(rawValue: outType) ?? GlobalColor.defaultOutputType
        }
        if let decimals = defaults.object(forKey: "useDecimals") as? Dictionary<String, Bool> {
            GlobalColor.useDecimals = decimals
        }
        if let illuminant = defaults.object(forKey: "illuminant") as? String {
            GlobalColor.illuminant = Illuminant(rawValue: illuminant) ?? .d65
        }
    }
    
    func reset() {
        GlobalColor.color = GlobalColor.defaultColor
        GlobalColor.inputType = GlobalColor.defaultInputType
        GlobalColor.outputType = GlobalColor.defaultOutputType
        GlobalColor.useDecimals = GlobalColor.defaultDecimals
        GlobalColor.illuminant = .d65
        
        defaults.set(GlobalColor.defaultColorNS, forKey: "color")
        defaults.set(GlobalColor.defaultInputTypeNS, forKey: "inType")
        defaults.set(GlobalColor.defaultOutputTypeNS, forKey: "outType")
        defaults.set(GlobalColor.defaultDecimalsNS, forKey: "useDecimals")
        
        defaults.set("d65", forKey: "illuminant")
    }
}



