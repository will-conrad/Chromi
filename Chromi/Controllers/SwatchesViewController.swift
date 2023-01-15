//
//  SwatchesViewController.swift
//  Chromi
//
//  Created by Will Conrad on 1/15/23.
//

import UIKit

class SwatchesViewController: UIViewController {

    
    @IBOutlet var colorBarContainerView: UIView!
    @IBOutlet var swatchContainerView: UIView!
    
    @IBOutlet var inputColorStack: UIStackView!
    
    @IBOutlet var inputColorLabel: SRCopyableLabel!
    
    var colorBarView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let padding: CGFloat = 7
        
        colorBarView = UIView(
           frame: CGRect(
                   x: padding,
                   y: padding,
                   width: colorBarContainerView.frame.width - 2*padding,
                   height: colorBarContainerView.frame.height - 2*padding))
       colorBarView.layer.cornerRadius = 10
        swatchContainerView.layer.cornerRadius = 10
       colorBarView.backgroundColor = GlobalColor.color
       
       colorBarContainerView.addSubview(colorBarView)
       inputColorStack.layer.cornerRadius = 10
       
       inputColorLabel.text = colorToText(color: GlobalColor.color, type: GlobalColor.inputType)
       

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        colorBarView.backgroundColor = GlobalColor.color
        inputColorLabel.text = colorToText(color: GlobalColor.color, type: GlobalColor.inputType)
    }
    
}

