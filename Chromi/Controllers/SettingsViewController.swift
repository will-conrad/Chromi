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

        // Do any additional setup after loading the view.
    }
    
    @IBAction func resetDefaults(_ sender: Any) {
        defaults.set(GlobalColor.defaultColorNS, forKey: "color")
        defaults.set(GlobalColor.defaultInputTypeNS, forKey: "inType")
        defaults.set(GlobalColor.defaultOutputTypeNS, forKey: "outType")
        GlobalColor().reset()
        
        NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)

        print(GlobalColor.color)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
