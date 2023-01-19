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

    let testDataTitles: [String] = ["R21", "R50", "R62"]
    let testDataDescs: [String] = ["Midnight Blue", "Bastard Amber", "Forrest Green"]
    let testDataColors: [UIColor] = [UIColor(hex: "00015B"), UIColor(hex: "FFA588"), UIColor(hex: "007802")]
    
    var colorBarView = UIView()
    var data: [[String]] = [[String]]()
    var swatchType: SwatchType = .gel
    
    // MARK: IBACTIONS
    @IBAction func typeChanged(_ sender: Any) {
        switch swatchTypeControl.selectedSegmentIndex {
        case 0: //Gels
            swatchType = .gel
        case 1:
            swatchType = .pantone
        default:
            swatchType = .gel
        }
        data = [[String]]()
        getSwatches()
        swatchTable.reloadData()
    }
    // MARK: VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: Notification.Name("refresh"), object: nil)
        
        swatchTypeControl.selectedSegmentIndex = 0
        data = fetchCSV(type: .gel)
        
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
        
        swatchContainerView.layer.cornerRadius = 10
        swatchTable.dataSource = self
    }
    // MARK: FUNCS
    override func viewWillAppear(_ animated: Bool) {
        reload()
        data = [[String]]()
        getSwatches()
        swatchTable.reloadData()
    }
    @objc func refresh (notification: NSNotification) { reload() }
    
    func reload() {
        colorBarView.backgroundColor = GlobalColor.color
        inputColorLabel.text = colorToText(color: GlobalColor.color, type: GlobalColor.inputType)
    }
    
    func fetchCSV(type: SwatchType) -> [[String]] {
        if type == .pantone {
            return SavedCSVData.pantoneCSV
        }
        return SavedCSVData.roscoCSV
    }
    func getSwatches() {
        if swatchType == .gel {
            //
        } else {
            for line in SavedCSVData.pantoneCSV {
                print(colorDistance(GlobalColor.color, UIColor(hex: line[1])))
                if colorDistance(GlobalColor.color, UIColor(hex: line[1])) < 0.2 {
                    data.append(line)
                }
            }
        }
    }
    func colorDistance(_ c1: UIColor, _ c2: UIColor) -> Double {
        let (c1r, c1g, c1b) = c1.rgb
        let (c2r, c2g, c2b) = c2.rgb
        return sqrt(pow(c1r-c2r, 2) + pow(c1g-c2g, 2) + pow(c1b-c2b, 2))
    }
    
}
// MARK: - INIT CELLS
extension SwatchesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "swatchCell", for: indexPath) as! SwatchCell
        cell.cellType = swatchType
        cell.titleText = data[indexPath.row][0]
        cell.color = UIColor(hex: data[indexPath.row][1])
        if data[indexPath.row].count == 3 {
            cell.descText = data[indexPath.row][2]
        } else {
            cell.descText = ""
        }
        
        return cell
        
    }
}

