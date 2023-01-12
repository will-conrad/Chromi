//
//  SchemesViewController.swift
//  Chromi
//
//  Created by Will Conrad on 1/12/23.
//

import UIKit

class SchemesViewController: UIViewController {
    
    @IBOutlet var inputColorStack: UIStackView!
    @IBOutlet var colorBarContainerView: UIView!
    
    var colorBarView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(colorBarContainerView.frame.width)
       
         colorBarView = UIView(
            frame: CGRect(
                    x: 7,
                    y: 7,
                    width: colorBarContainerView.frame.width - 14,
                    height: colorBarContainerView.frame.height - 14))
        
        colorBarView.layer.cornerRadius = 10
        colorBarView.backgroundColor = GlobalColor.color
        
        colorBarContainerView.addSubview(colorBarView)
        inputColorStack.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        colorBarView.backgroundColor = GlobalColor.color
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
