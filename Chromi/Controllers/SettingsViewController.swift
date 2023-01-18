//
//  SettingsViewController.swift
//  Chromi
//
//  Created by Will Conrad on 12/26/22.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet var useDecimalsSwitch: UISwitch!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        useDecimalsSwitch.isOn = defaults.bool(forKey: "useDecimals")
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func resetDefaults(_ sender: Any) {
        
        
        useDecimalsSwitch.isOn = false
        GlobalColor().reset()
        
        NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
    }
    @IBAction func displayTypeSwitched(_ sender: Any) {
        if useDecimalsSwitch.isOn {
            GlobalColor.useDecimals = true
        } else {
            GlobalColor.useDecimals = false
        }
        defaults.set(useDecimalsSwitch.isOn, forKey: "useDecimals")
        NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
    }
}
