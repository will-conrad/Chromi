//
//  SwatchCell.swift
//  Chromi
//
//  Created by Will Conrad on 1/15/23.
//

import Foundation
import UIKit

class SwatchCell: UITableViewCell {
    var cellType: SwatchType = .gel
    var titleText: String = ""
    var descText: String = ""
    var color: UIColor? = UIColor.black
    
    @IBOutlet var colorCircleView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        colorCircleView.layer.cornerRadius = colorCircleView.frame.width / 2
        colorCircleView.backgroundColor = color
    
        if cellType == .gel {
            titleLabel.text = "R\(titleText)"
        } else {
            titleLabel.text = titleText
        }

        if descText == "" {
            descLabel.text = color?.hex ?? ""
        } else {
            descLabel.text = "\(color?.hex ?? "") - \(descText)"
        }
    }
}
