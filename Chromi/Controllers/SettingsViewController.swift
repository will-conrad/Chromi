//
//  SettingsViewController.swift
//  Chromi
//
//  Created by Will Conrad on 12/26/22.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func resetDefaults(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(GlobalColor.defaultColorNS, forKey: "color")
        defaults.set(GlobalColor.defaultInputTypeNS, forKey: "inType")
        defaults.set(GlobalColor.defaultOutputTypeNS, forKey: "outType")
        
        GlobalColor().reset()
        NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)

        print(GlobalColor.color)
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
