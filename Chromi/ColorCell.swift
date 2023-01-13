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
    @IBOutlet var textBackdropWidth: NSLayoutConstraint!
    
    @IBOutlet var colorLabel: SRCopyableLabel!
    var color = UIColor()
    var type = ColorType.rgb
    var colorText = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.cellView.backgroundColor = color
        self.colorText = colorToText(color: color, type: type)

        
        colorLabel.textColor = UIColor.lightGray
        colorLabel.text = colorText
        
        textBackdropView.layer.cornerRadius = 10
        print(cellView.frame.width)
        textBackdropWidth.constant = cellView.frame.width / 2 - 10
        
        // Configure the view for the selected state
    }

}
