//
//  SwatchesViewController.swift
//  Chromi
//
//  Created by Will Conrad on 1/15/23.
//

import UIKit
enum SwatchType {
    case gel
    case pantone
}
class SwatchesViewController: UIViewController {

    
    @IBOutlet var colorBarContainerView: UIView!
    @IBOutlet var swatchContainerView: UIView!
    
    @IBOutlet var swatchTypeControl: UISegmentedControl!
    @IBOutlet var swatchTable: UITableView!
    @IBOutlet var inputColorStack: UIStackView!
    
    @IBOutlet var inputColorLabel: SRCopyableLabel!
    
    var colorBarView = UIView()
    
    let testDataTitles: [String] = ["R21", "R50", "R62"]
    let testDataDescs: [String] = ["Midnight Blue", "Bastard Amber", "Forrest Green"]
    let testDataColors: [UIColor] = [UIColor(hex: "00015B"), UIColor(hex: "FFA588"), UIColor(hex: "007802")]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let padding: CGFloat = 7
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.Name("reload"), object: nil)
        
        colorBarView = UIView(
           frame: CGRect(
                   x: padding,
                   y: padding,
                   width: colorBarContainerView.frame.width - 2*padding,
                   height: colorBarContainerView.frame.height - 2*padding))
        colorBarView.layer.cornerRadius = 10
        swatchContainerView.layer.cornerRadius = 10
        colorBarView.backgroundColor = GlobalColor.color
       
        colorBarContainerView.addSubview(colorBarView)
        inputColorStack.layer.cornerRadius = 10
       
        inputColorLabel.text = colorToText(color: GlobalColor.color, type: GlobalColor.inputType)
        swatchTable.rowHeight = 65
        self.swatchTable.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reset()
    }
    
    @objc func reload (notification: NSNotification) {
        reset()
    }
    func reset() {
        colorBarView.backgroundColor = GlobalColor.color
        inputColorLabel.text = colorToText(color: GlobalColor.color, type: GlobalColor.inputType)
    }
    
}

extension SwatchesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "swatchCell", for: indexPath) as! SwatchCell
        cell.cellType = .gel
        cell.titleText = testDataTitles[indexPath.row]
        cell.descText = testDataDescs[indexPath.row]
        cell.color = testDataColors[indexPath.row]

        return cell
        
    }
}

