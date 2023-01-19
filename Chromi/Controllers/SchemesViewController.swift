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
    
    // MARK: IBACTIONS
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
    
    // MARK: OVERRIDES
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: Notification.Name("refresh"), object: nil)
        
        let padding: CGFloat = 7
        
        //Color display bar
        colorBarView = UIView(
            frame: CGRect(
                    x: padding,
                    y: padding,
                    width: colorBarContainerView.frame.width - 2*padding,
                    height: colorBarContainerView.frame.height - 2*padding))
        colorBarView.layer.cornerRadius = 10
        colorBarView.backgroundColor = GlobalColor.color
        colorBarContainerView.addSubview(colorBarView)
        
        //Input color text
        inputColorStack.layer.cornerRadius = 10
        inputColorLabel.text = colorToText(color: GlobalColor.color, type: GlobalColor.inputType)
        
        //Scheme table
        schemeView.layer.cornerRadius = 10
        schemeTypeText.text = schemeType.rawValue.uppercased()
        schemeTypeButton.showsMenuAsPrimaryAction = true
        schemeTypeButton.menu = schemeTypeContextMenu()
        
        schemeTable.contentInset = UIEdgeInsets.init(top: -30, left: 0, bottom: 0, right: 0)
        schemeTable.dataSource = self
        schemeTable.isScrollEnabled = true

        schemeColors = getScheme(scheme: schemeType)
    }
    override func viewWillAppear(_ animated: Bool) { reload() }
    @objc func refresh (notification: NSNotification){ reload() }
    
    // MARK: FUNCS
    func reload() {
        colorBarView.backgroundColor = GlobalColor.color
        inputColorLabel.text = colorToText(color: GlobalColor.color, type: GlobalColor.inputType)
        updateTabs()
    }
    func updateTabs() {
        schemeColors = getScheme(scheme: schemeType)
        schemeTypeText.text = schemeType.rawValue.uppercased()
        schemeTable.reloadData()
    }
    func getScheme(scheme: ColorScheme)-> [UIColor] {
        switch scheme {
        case .complementary:
            return GlobalColor.color.complementary
        case .splitComplementary:
            return GlobalColor.color.splitComplementary
        case .square:
            return GlobalColor.color.square
        case .tetradic:
            return GlobalColor.color.tetradic
        case .triadic:
            return GlobalColor.color.triadic
        case .analogous:
            return GlobalColor.color.analagous
        }
    }
    func schemeTypeContextMenu() -> UIMenu {
        var actions: [UIAction] = []
        for scheme in ColorScheme.allCases {
            let name = scheme.rawValue
            actions.append(
                UIAction(title: name, state: schemeType == scheme ? .on : .off) { _ in
                    self.schemeTypeButton.setTitle(scheme.rawValue, for: .normal)
                    self.schemeType = scheme
                    self.updateTabs()
            })
        }
        let schemeTypeContextMenu = UIMenu(title: "Scheme Type", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: actions)
        return schemeTypeContextMenu
    }
}

// MARK: - INIT CELLS
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
}
