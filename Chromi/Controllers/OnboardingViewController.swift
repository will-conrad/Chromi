//
//  OnboardingViewController.swift
//  Chromi
//
//  Created by Will Conrad on 1/19/23.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet var fish: UIImageView!
    
    @IBOutlet var fishToRight: NSLayoutConstraint!
    @IBOutlet var fishToTop: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fishToTop.constant = 500
        fishToRight.constant = 200
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.animateFish()
        }
    }
    func animateFish() {
        let topFinal: CGFloat = 258
        let rightFinal: CGFloat = 34
        
        let topOff: CGFloat = 0
        let rightOff: CGFloat = -505
        
        self.view.setNeedsLayout()
        
        self.fishToTop.constant = topFinal
        self.fishToRight.constant = rightFinal
        
        UIView.animate(withDuration: 1.5, delay: 0, options: [.curveEaseOut, .preferredFramesPerSecond60], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.view.setNeedsLayout()
            self.fishToTop.constant = topOff
            self.fishToRight.constant = rightOff
            UIView.animate(withDuration: 2, delay: 0, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
            
        }
        
        
    }
    
}
