//
//  GlobalColor.swift
//  Chromi
//
//  Created by Will Conrad on 1/12/23.
//

import Foundation
import UIKit

class GlobalColor: NSObject {
    //Global values + app init values
    static var color = UIColor(hexString: "#5865F2")
    static var inputType = ColorType.rgb
    static var outputType = ColorType.hex
    
    override init() {
        super.init()
        let colorDefaults = UserDefaults.standard
       
        if let color = colorDefaults.object(forKey: "color") as? String {
            GlobalColor.color = UIColor(hexString: color)
        }
    }
    
    static func getData() -> NSString {
        return self.color.hex as NSString
    }
}

class GlobalColorData: NSObject {
    
}



