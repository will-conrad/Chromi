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
    
    @IBOutlet var schemeTypeText: UILabel!
    @IBOutlet var schemeTable: UITableView!
    
    @IBOutlet var copyAllButton: UIButton!
    var schemeType: ColorScheme = .complementary
    var schemeColors: [UIColor] = []
     
    var colorBarView = UIView()

    
    func schemeTypeContextMenu() -> UIMenu {
        let complementary = UIAction(title: "Complementary", state: schemeType == .complementary ? .on : .off) { _ in
            self.schemeTypeButton.setTitle("Complementary", for: .normal)
            self.schemeType = .complementary
            self.updateTabs()
        }
        let splitComplementary = UIAction(title: "Split Complementary", state: schemeType == .splitComplementary ? .on : .off) { _ in
            self.schemeTypeButton.setTitle("Split Complementary", for: .normal)
            self.schemeType = .splitComplementary
            self.updateTabs()
        }
        let tetradic = UIAction(title: "Tetradic", state: schemeType == .tetradic ? .on : .off) { _ in
            self.schemeTypeButton.setTitle("Tetradic", for: .normal)
            self.schemeType = .tetradic
            self.updateTabs()
        }
        let triadic = UIAction(title: "Triadic", state: schemeType == .triadic ? .on : .off) { _ in
            self.schemeTypeButton.setTitle("Triadic", for: .normal)
            self.schemeType = .triadic
            self.updateTabs()
        }
        let analogous = UIAction(title: "Analogous", state: schemeType == .analogous ? .on : .off) { _ in
            self.schemeTypeButton.setTitle("Analogous", for: .normal)
            self.schemeType = .analogous
            self.updateTabs()
        }
        let schemeTypeContextMenu = UIMenu(title: "Scheme Type", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [complementary, splitComplementary, tetradic, triadic, analogous])
        return schemeTypeContextMenu
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        schemeTable.rowHeight = 50

        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.Name("reload"), object: nil)
        
        
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
        
        self.schemeTable.contentInset = UIEdgeInsets.init(top: -30, left: 0, bottom: 0, right: 0)
        schemeTypeText.text = schemeType.rawValue.uppercased()
        
        
        self.schemeTable.dataSource = self
        self.schemeTable.isScrollEnabled = true

        schemeTypeButton.showsMenuAsPrimaryAction = true
        schemeTypeButton.menu = schemeTypeContextMenu()
        
        schemeColors = getScheme(scheme: schemeType)
        
    }
    
    func getScheme(scheme: ColorScheme)-> [UIColor] {
        switch scheme {
        case .complementary:
            return GlobalColor.color.complementary
        case .splitComplementary:
            return GlobalColor.color.splitComplementary
        case .tetradic:
            return GlobalColor.color.tetradic
        case .triadic:
            return GlobalColor.color.triadic
        case .analogous:
            return GlobalColor.color.analagous
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reset()
    }
    @objc func reload (notification: NSNotification){
       reset()
        
    }
    func reset() {
        colorBarView.backgroundColor = GlobalColor.color
        inputColorLabel.text = colorToText(color: GlobalColor.color, type: GlobalColor.inputType)
        schemeColors = getScheme(scheme: schemeType)
        schemeTypeText.text = schemeType.rawValue.uppercased()
        schemeTable.reloadData()
    }
    
    @IBAction func copyAll(_ sender: Any) {
        var schemeString = ""
        for color in schemeColors {
            schemeString = schemeString + colorToText(color: color, type: GlobalColor.inputType) + "\n"
        }
        UIPasteboard.general.string = schemeString
        self.copyAllButton.setTitle("Copied!", for: .normal)
        self.copyAllButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.copyAllButton.setTitle("Copy All", for: .normal)
            self.copyAllButton.setImage(UIImage(systemName: "doc.on.clipboard"), for: .normal)
        }
        
    }
    func updateTabs() {
        schemeColors = getScheme(scheme: schemeType)
        schemeTypeText.text = schemeType.rawValue.uppercased()

        schemeTable.reloadData()
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
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return schemeType.rawValue
//    }
}
