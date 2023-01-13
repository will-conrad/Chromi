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
    
    @IBOutlet var schemeTypeButton: UIButton!
    
    @IBOutlet var schemeTable: UITableView!
    
    var schemeType: ColorScheme = .splitComplementary
    var schemeColors: [UIColor] = []
     
    
    var colorBarView = UIView()
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
        
        colorBarView.layer.cornerRadius = 10
        colorBarView.backgroundColor = GlobalColor.color
        
        colorBarContainerView.addSubview(colorBarView)
        inputColorStack.layer.cornerRadius = 10
        
        inputColorLabel.text = colorToText(color: GlobalColor.color, type: GlobalColor.inputType)
        
        
        schemeTable.delegate = self
        schemeTable.dataSource = self
        schemeTable.isScrollEnabled = false
        schemeColors = GlobalColor.color.splitComplementary
        
        schemeTypeButton.titleEdgeInsets.right = 0;
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        schemeTable.reloadData()
        colorBarView.backgroundColor = GlobalColor.color
        inputColorLabel.text = colorToText(color: GlobalColor.color, type: GlobalColor.inputType)
        schemeColors = GlobalColor.color.splitComplementary

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
}
