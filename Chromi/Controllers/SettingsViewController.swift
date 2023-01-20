//
//  SettingsViewController.swift
//  Chromi
//
//  Created by Will Conrad on 12/26/22.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet var backButton: UIButton!
    @IBOutlet var infoButton: UIButton!
    @IBOutlet var superView: UIView!
    
    var settingsTable =  UITableView(frame: CGRect(), style: .insetGrouped)
    
    let defaults = UserDefaults.standard
    let types: [ColorType] = [.rgb, .hsl, .hsv, .cmyk, .ciexyz, .cielab]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsTable.frame = CGRect(x: 0, y: 0, width: superView.frame.width, height: superView.frame.height)
        settingsTable.delegate = self
        settingsTable.dataSource = self
        superView.addSubview(settingsTable)
        settingsTable.reloadData()
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
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
        return 3
    }
    //NUM ROWS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2 //Illuminant
        case 1:
            return types.count //Use decimals
        case 2:
            return 1
        
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
            return "Decimals"
        default:
            return ""
        }
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        //FOOTER
        switch section {
        case 0:
            return "The reference illuminant to use when calculating CIEXYZ and CIELAB values."
        case 1:
            return "Whether or not to scale values from 0-1.\n\(GlobalColor.useDecimals["rgb"]! ? "Example: RGB = (0, 0.5, 1)" : "Example: RGB = (0, 128, 255)")"
        default:
            return ""
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 30 : 50
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
            let type = types[indexPath.row]
            cell.textLabel!.text = "Use decimals for \(type.rawValue.uppercased()) values"
            
            let toggle = ColorSwitch(frame: .zero, type: type)
            toggle.isOn = GlobalColor.useDecimals[type.rawValue]!
            toggle.addTarget(self, action: #selector(self.toggled), for: .valueChanged)
            
            cell.accessoryView = toggle
        case 2:
            var button = UIButton(type: .system)
            button.frame = cell.frame
            
            button.setTitle("Reset App Defaults", for: .normal)
            button.titleLabel?.font = UIFont(name: "body", size: 1)
            button.addTarget(self, action: #selector(self.resetButton), for: .touchUpInside)
           
            cell.accessoryView = button
        default:
            break
        }
        return cell
    }
    @objc func resetButton(_ sender : UIButton!) {
        GlobalColor().reset()
        refreshControllers()
        settingsTable.reloadData()
    }
    @objc func toggled(_ sender : ColorSwitch!){
        if sender.isOn {
            GlobalColor.useDecimals[sender.type.rawValue] = true
        } else {
            GlobalColor.useDecimals[sender.type.rawValue] = false
        }
        defaults.set(GlobalColor.useDecimalsNS, forKey: "useDecimals")
        settingsTable.reloadData()
        refreshControllers()
    }
}
