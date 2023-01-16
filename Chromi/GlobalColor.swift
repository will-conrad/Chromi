//
//  GlobalColor.swift
//  Chromi
//
//  Created by Will Conrad on 1/12/23.
//

import Foundation
import UIKit

class GlobalColor {
    static var color = UIColor(hexString: "#5865F2")
    static var inputType = ColorType.rgb
    static var outputType = ColorType.hex
    
    //Pull defaults from UserDefaults
     init() {
        let defaults = UserDefaults.standard
       
        if let color = defaults.object(forKey: "hexColor") as? String {
            GlobalColor.color = UIColor(hexString: color)
        }
        if let inType = defaults.object(forKey: "inType") as? String {
            GlobalColor.inputType = ColorType(rawValue: inType) ?? .rgb
        }
        if let outType = defaults.object(forKey: "outType") as? String {
            GlobalColor.outputType = ColorType(rawValue: outType) ?? .hex
        }
    }
    
    static func getData() -> NSString {
        return self.color.hex as NSString
    }
}



