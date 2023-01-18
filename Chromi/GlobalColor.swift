//
//  GlobalColor.swift
//  Chromi
//
//  Created by Will Conrad on 1/12/23.
//

import Foundation
import UIKit

class GlobalColor {
    static var useDecimals = true
    
    static var color = defaultColor
    static var inputType = defaultInputType
    static var outputType = defaultOutputType
    
    static var colorNS: NSString {
        return self.color.hex as NSString
    }
    static var inTypeNS: NSString {
        return self.inputType.rawValue as NSString
    }
    static var outTypeNS: NSString {
        return self.outputType.rawValue as NSString
    }
    
    static let defaultColor = UIColor(hex: "#5865F2")
    static let defaultColorNS = defaultColor.hex as NSString
    
    static let defaultInputType = ColorType.rgb
    static let defaultInputTypeNS = defaultInputType.rawValue as NSString
    
    static let defaultOutputType = ColorType.hex
    static let defaultOutputTypeNS = defaultOutputType.rawValue as NSString
    
    //Pull defaults from UserDefaults
    init() {
        let defaults = UserDefaults.standard
        
        if let color = defaults.object(forKey: "color") as? String {
            GlobalColor.color = UIColor(hex: color)
        }
        if let inType = defaults.object(forKey: "inType") as? String {
            GlobalColor.inputType = ColorType(rawValue: inType) ?? .rgb
        }
        if let outType = defaults.object(forKey: "outType") as? String {
            GlobalColor.outputType = ColorType(rawValue: outType) ?? .hex
        }
        GlobalColor.useDecimals = defaults.bool(forKey: "useDecimals")
    }
    
    func reset() {
        GlobalColor.color = GlobalColor.defaultColor
        GlobalColor.inputType = GlobalColor.defaultInputType
        GlobalColor.outputType = GlobalColor.defaultOutputType
        GlobalColor.useDecimals = false
    }
}



