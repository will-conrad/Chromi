//
//  SettingsViewController.swift
//  Chromi
//
//  Created by Will Conrad on 12/26/22.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet var useDecimalsSwitch: UISwitch!
    
    @IBOutlet var superView: UIView!
    var settingsTable =  UITableView(frame: CGRect(), style: .insetGrouped)
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        useDecimalsSwitch.isOn = defaults.bool(forKey: "useDecimals")
        
        settingsTable.frame = CGRect(x: 0, y: 0, width: superView.frame.width, height: superView.frame.height)
        settingsTable.delegate = self
        settingsTable.dataSource = self
        superView.addSubview(settingsTable)
        settingsTable.reloadData()
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
extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch section {
//        case 0:
//            return 2
//        case 1:
//            return 1
//        default:
//            return 0
//        }
        return 3
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        switch section {
//        case 0:
//            return "Illuminant Reference"
//        default:
//            return ""
//        }
        return "TEST"
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "TEST"
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: .default, reuseIdentifier: "cellIdentifier")
        
        return cell
    }
    
}
