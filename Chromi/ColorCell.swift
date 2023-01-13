//
//  ColorCell.swift
//  Chromi
//
//  Created by Will Conrad on 1/12/23.
//

import UIKit

class ColorCell: UITableViewCell {

    @IBOutlet var cellView: UIView!
    @IBOutlet var textBackdropView: UIView!
    
    @IBOutlet public var colorLabel: SRCopyableLabel!
    var color = UIColor()
    var type = ColorType.rgb
    var colorText = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print("setSelected")
        
        cellView.backgroundColor = color
        colorText = colorToText(color: color, type: type)

        
        colorLabel.textColor = UIColor.lightGray
        colorLabel.text = colorText
        
        textBackdropView.layer.cornerRadius = 10
        
        
        
        // Configure the view for the selected state
    }

}
