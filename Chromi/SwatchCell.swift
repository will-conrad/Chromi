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
    var match = false
    var matchPercent = 0.0
    
    @IBOutlet var colorCircleView: UIView!
    @IBOutlet var titleLabel: CopyableLabel!
    @IBOutlet var descLabel: CopyableLabel!
    @IBOutlet var matching: UIImageView!
    @IBOutlet var percent: UILabel!
    
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
        if color?.hex == GlobalColor.color.hex {
            matching.isHidden = false
        } else {
            matching.isHidden = true
        }
        if color != nil {
            percent.text = "\(truncate(matchPercent))%"
        } else {
            percent.text = ""
        }
    }
    
    func truncate(_ x: Double) -> Double {
        let negative = x<0
        let decimals = 1
        let n = pow(10.0, decimals).doubleValue
        let trunc = abs(ceil(x * n)/n)
        return negative && trunc != 0 ? -1 * trunc : trunc
    }
}
