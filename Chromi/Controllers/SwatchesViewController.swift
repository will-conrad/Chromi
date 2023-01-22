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
    @IBOutlet var colorBarView: UIView!
    @IBOutlet var swatchContainerView: UIView!
    @IBOutlet var swatchTypeControl: UISegmentedControl!
    @IBOutlet var swatchTable: UITableView!
    @IBOutlet var inputColorStack: UIStackView!
    @IBOutlet var inputColorLabel: SRCopyableLabel!
    @IBOutlet var thresholdSlider: UISlider!
    
    var data: [[String]] = [[String]]()
    var swatchType: SwatchType = .gel
    
    var threshold: Double = 0.1
    
    // MARK: IBACTIONS
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        threshold = Double(sender.value)
        data = [[String]]()
        getSwatches()
        swatchTable.reloadData()
    }
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
        overrideUserInterfaceStyle = .dark

        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: Notification.Name("refresh"), object: nil)
        
        swatchTypeControl.selectedSegmentIndex = 0
        data = fetchCSV(type: .gel)
        
        
        colorBarView.layer.cornerRadius = 10
        colorBarView.backgroundColor = GlobalColor.color
        
        inputColorStack.layer.cornerRadius = 10
        inputColorLabel.text = colorToText(color: GlobalColor.color, type: GlobalColor.inputType)
        
        swatchContainerView.layer.cornerRadius = 10
        swatchTable.dataSource = self
    }
    // MARK: FUNCS
    override func viewWillAppear(_ animated: Bool) {
        reload()
    }
    @objc func refresh (notification: NSNotification) { reload() }
    
    func reload() {
        colorBarView.backgroundColor = GlobalColor.color
        inputColorLabel.text = colorToText(color: GlobalColor.color, type: GlobalColor.inputType)
        data = [[String]]()
        getSwatches()
        swatchTable.reloadData()
    }
    
    func fetchCSV(type: SwatchType) -> [[String]] {
        if type == .pantone {
            return SavedCSVData.pantoneCSV
        }
        return SavedCSVData.roscoCSV
    }
    func getSwatches() {
        if swatchType == .gel {
            for line in SavedCSVData.roscoCSV {
                print(colorDistance(GlobalColor.color, UIColor(hex: line[1])))
                if colorDistance(GlobalColor.color, UIColor(hex: line[1])) < threshold {
                    data.append(line)
                }
            }
        } else {
            for line in SavedCSVData.pantoneCSV {
                print(colorDistance(GlobalColor.color, UIColor(hex: line[1])))
                if colorDistance(GlobalColor.color, UIColor(hex: line[1])) < threshold {
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
        return max(1, data.count)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "swatchCell", for: indexPath) as! SwatchCell
        
        if data.count == 0 {
            cell.cellType = .pantone
            cell.titleText = "No Swatches Found"
            cell.color = nil
            cell.descText = ""
        } else {
            cell.cellType = swatchType
            cell.titleText = data[indexPath.row][0]
            cell.color = UIColor(hex: data[indexPath.row][1])
            if data[indexPath.row].count == 3 {
                cell.descText = data[indexPath.row][2]
            } else {
                cell.descText = ""
            }
        }
        
        return cell
        
    }
}

