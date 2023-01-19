//
//  ColorSwitch.swift
//  Chromi
//
//  Created by Will Conrad on 1/18/23.
//

import UIKit

class ColorSwitch: UISwitch {
    var type: ColorType = .rgb
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    convenience init(frame: CGRect, type: ColorType) {
        self.init(frame: frame)
        self.type = type
    }
}
