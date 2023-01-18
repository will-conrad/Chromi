//
//  SettingsViewController.swift
//  Chromi
//
//  Created by Will Conrad on 12/26/22.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet var backButton: UIButton!
    @IBOutlet var useDecimalsSwitch: UISwitch!
    @IBOutlet var superView: UIView!
    
    var settingsTable =  UITableView(frame: CGRect(), style: .insetGrouped)
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.frame.origin = CGPoint(x: -10, y: 0)
        
        useDecimalsSwitch.isOn = defaults.bool(forKey: "useDecimals")
        
        let yOffset: CGFloat = 160
        settingsTable.frame = CGRect(x: 0, y: yOffset, width: superView.frame.width, height: superView.frame.height - yOffset)
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
        refreshControllers()
    }
    
    func refreshControllers() {
        NotificationCenter.default.post(name: Notification.Name("refresh"), object: nil)
    }
}
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = settingsTable.cellForRow(at: indexPath) {
            
            switch indexPath.section {
            case 0:
                if indexPath.row == 0 && GlobalColor.illuminant != .d65 {
                    cell.accessoryType = .checkmark
                    GlobalColor.illuminant = .d65
                    defaults.set("d65", forKey: "illuminant")
                    
                }
                else if indexPath.row == 1 && GlobalColor.illuminant != .d50 {
                    cell.accessoryType = .checkmark
                    GlobalColor.illuminant = .d50
                    defaults.set("d50", forKey: "illuminant")
                }
            default:
                break
            }
        }
        refreshControllers()
        settingsTable.reloadData()
    }
}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    //NUM ROWS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2 //Illuminant
        case 1:
            return 2 //Use decimals
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //HEADER TITLE
        switch section {
        case 0:
            return "Illuminant"
        case 1:
            return ""
        default:
            return ""
        }
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        //FOOTER
        switch section {
        case 0:
            return "The reference illuminant to use when calculating CIEXYZ and CIELAB values"
        case 1:
            return GlobalColor.useDecimals ? "Example: RGB = (0, 0.5, 1)" : "Example: RGB = (0, 128, 255)"
        default:
            return ""
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: .default, reuseIdentifier: "cellIdentifier")
        switch indexPath.section {
        case 0: // D65
            if indexPath.row == 0 {
                cell.textLabel!.text = "D65 (Default)"
                cell.accessoryType = GlobalColor.illuminant == .d65 ? .checkmark : .none
            }
            else if indexPath.row == 1 {
                cell.textLabel!.text = "D50"
                cell.accessoryType = GlobalColor.illuminant == .d50 ? .checkmark : .none
            }
        case 1:
            var toggle = UISwitch(frame: .zero)
            toggle.isOn = GlobalColor.useDecimals
            cell.textLabel!.text = "Use decimal values"
            toggle.addTarget(self, action: #selector(self.toggled), for: .valueChanged)
            cell.accessoryView = toggle
            
        default:
            break
        }
        return cell
    }
    
    @objc func toggled(_ sender : UISwitch!){
        if sender.isOn {
            GlobalColor.useDecimals = true
        } else {
            GlobalColor.useDecimals = false
        }
        defaults.set(sender.isOn, forKey: "useDecimals")
        settingsTable.reloadData()
        refreshControllers()
    }

    
}
