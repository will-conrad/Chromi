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
    @IBOutlet var inputColorLabel: UILabel!
    
    @IBOutlet var schemeView: UIView!
    @IBOutlet var schemeTypeButton: UIButton!
    
    @IBOutlet var schemeTable: UITableView!
    
    var schemeType: ColorScheme = .complementary
    var schemeColors: [UIColor] = []
     
    var colorBarView = UIView()

    
    func schemeTypeContextMenu() -> UIMenu {
        let complementary = UIAction(title: "Complementary", state: schemeType == .complementary ? .on : .off) { _ in
            self.schemeTypeButton.setTitle("Complementary", for: .normal)
            self.schemeType = .complementary
            
        }
//        let splitComplementary = UIAction(title: "HSL", state: GlobalColor.outputType == .hsl ? .on : .off) { _ in
//            print("HSL")
//            self.outputTypeButton.setTitle("HSL", for: .normal)
//            GlobalColor.outputType = .hsl
//            self.updateOutputColorField()
//        }
//        let hsvOut = UIAction(title: "HSV", state: GlobalColor.outputType == .hsv ? .on : .off) { _ in
//            print("HSV")
//            self.outputTypeButton.setTitle("HSV", for: .normal)
//            GlobalColor.outputType = .hsv
//            self.updateOutputColorField()
//        }
//        let cmykOut = UIAction(title: "CMYK", state: GlobalColor.outputType == .cmyk ? .on : .off) { _ in
//            print("CMYK")
//            self.outputTypeButton.setTitle("CMYK", for: .normal)
//            GlobalColor.outputType = .cmyk
//            self.updateOutputColorField()
//        }
//        let hexOut = UIAction(title: "HEX", state: GlobalColor.outputType == .hex ? .on : .off) { _ in
//            print("HEX")
//            self.outputTypeButton.setTitle("HEX", for: .normal)
//            GlobalColor.outputType = .hex
//            self.updateOutputColorField()
//        }
        let schemeTypeContextMenu = UIMenu(title: "Scheme Type", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [complementary])
        return schemeTypeContextMenu
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        schemeTable.rowHeight = 49

        print(colorBarContainerView.frame.width)
        
        
        let padding: CGFloat = 7
        
         colorBarView = UIView(
            frame: CGRect(
                    x: padding,
                    y: padding,
                    width: colorBarContainerView.frame.width - 2*padding,
                    height: colorBarContainerView.frame.height - 2*padding))
        schemeView.layer.cornerRadius = 10
        colorBarView.layer.cornerRadius = 10
        colorBarView.backgroundColor = GlobalColor.color
        
        colorBarContainerView.addSubview(colorBarView)
        inputColorStack.layer.cornerRadius = 10
        
        inputColorLabel.text = colorToText(color: GlobalColor.color, type: GlobalColor.inputType)
        
        
        schemeTable.delegate = self
        schemeTable.dataSource = self
        schemeTable.isScrollEnabled = false
        
        
        
        schemeTypeButton.showsMenuAsPrimaryAction = true
        schemeTypeButton.menu = schemeTypeContextMenu()
        
        schemeColors = getScheme(scheme: schemeType)
    }
    
    func getScheme(scheme: ColorScheme)-> [UIColor] {
        switch scheme {
        case .complementary:
            return GlobalColor.color.complementary
            
        default:
            return []
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        schemeTable.reloadData()
        colorBarView.backgroundColor = GlobalColor.color
        inputColorLabel.text = colorToText(color: GlobalColor.color, type: GlobalColor.inputType)
        schemeColors = getScheme(scheme: schemeType)

    }
    
}

extension SchemesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Tapped")
        
    }
    
}
extension SchemesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schemeColors.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "colorCell", for: indexPath) as! ColorCell
        
        cell.color = schemeColors[indexPath.row]
        cell.type = GlobalColor.inputType
        
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return schemeType.rawValue
    }
}
