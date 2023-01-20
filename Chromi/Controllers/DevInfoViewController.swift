//
//  DevInfoViewController.swift
//  Chromi
//
//  Created by Will Conrad on 1/19/23.
//

import UIKit

class DevInfoViewController: UIViewController {
    
    var devTable =  UITableView(frame: CGRect(), style: .insetGrouped)
    let defaults = UserDefaults.standard

    @IBOutlet var superView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        devTable =  UITableView(frame: CGRect(), style: .insetGrouped)
        devTable.frame = CGRect(x: 0, y: 0, width: superView.frame.width, height: superView.frame.height)
        devTable.dataSource = self
        superView.addSubview(devTable)
        devTable.reloadData()
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension DevInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: .default, reuseIdentifier: "cellIdentifier")
        var button = UIButton(type: .system)
        button.frame = cell.frame
        
        button.setTitle("Reset app (quits appplication)", for: .normal)
        button.titleLabel?.font = UIFont(name: "body", size: 1)
        button.addTarget(self, action: #selector(self.resetButton), for: .touchUpInside)
       
        cell.accessoryView = button
        
        return cell
    }
    @objc func resetButton(_ sender : UIButton!) {
        GlobalColor().reset()
        defaults.set(true, forKey: "appFirstTime")
        exit(0)
    }
}
