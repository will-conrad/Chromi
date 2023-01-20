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
    
    @IBOutlet var continueBottom: NSLayoutConstraint!
    
    @IBOutlet var infoStack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isModalInPresentation = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        infoStack.isHidden = true
        fishToTop.constant = 500
        fishToRight.constant = 250
        continueBottom.constant = -75
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.animate()
        }
    }
    func animate() {
        let continueFinal:CGFloat = 50
        let topFinal: CGFloat = 258
        let rightFinal: CGFloat = 34
        
        let topOff: CGFloat = -50
        let rightOff: CGFloat = -505
        
        self.view.setNeedsLayout()
        
        self.fishToTop.constant = topFinal
        self.fishToRight.constant = rightFinal
        
        
        UIView.animate(withDuration: 1.5, delay: 0, options: [.preferredFramesPerSecond60], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.infoStack.isHidden = false
                self.view.setNeedsLayout()
                self.continueBottom.constant = continueFinal
                UIView.animate(withDuration: 1.5, delay: 0, options: [.curveEaseOut, .preferredFramesPerSecond60], animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
                
            }
            self.view.setNeedsLayout()
            self.fishToTop.constant = topOff
            self.fishToRight.constant = rightOff
            UIView.animate(withDuration: 2, delay: 0, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
            
        }
        
        
    }
    
    @IBAction func continuePressed(_ sender: Any) {
        dismiss(animated: true)
    }
}
