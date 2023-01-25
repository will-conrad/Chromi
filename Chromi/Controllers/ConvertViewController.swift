//
//  ConvertViewController.swift
//  Chromi
//
//  Created by Will Conrad on 1/11/23.
//

import UIKit

class ConvertViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var mainStackBottomConstraint: NSLayoutConstraint!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var colorSelector: UIColorWell!
    @IBOutlet var inputTypeButton: UIButton!
    @IBOutlet var inputColor: UITextField!
    @IBOutlet var outputTypeButton: UIButton!
    @IBOutlet var outputColorView: UIView!

    @IBOutlet var outputColorText: CopyableLabel!
//    var outputColorText = SRCopyableLabel(frame: CGRect(x: 10, y: 0, width: 200, height: 44))
//
    let defaults = UserDefaults.standard
    //padding
    
    // MARK: IBACTIONS
    @IBAction func inputColorUpdated(_ sender: Any) {
        if let color = parseInputColor(color: inputColor.text!, type: GlobalColor.inputType) {
            GlobalColor.color = color
            setDefaultColor()
        }
        updateElementColors()
        self.updateOutputColorField()
    }
    @IBAction func keyboardUp(_ sender: Any) {
        mainStackBottomConstraint.constant = 70
        self.view.setNeedsLayout()
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func keyboardDown(_ sender: Any) {
        mainStackBottomConstraint.constant = 130
        self.view.setNeedsLayout()
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    // MARK: OVERRIDES
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark

        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: Notification.Name("refresh"), object: nil)
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        if defaults.object(forKey: "appFirstTime") == nil {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.performSegue(withIdentifier: "Onboard", sender: nil)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.defaults.set(false, forKey: "appFirstTime")
            }
           
        }
        
        
        
        colorSelector.addTarget(self, action: #selector(colorSelectorUpdate), for: .valueChanged)
        colorSelector.selectedColor = GlobalColor.color
        colorSelectorUpdate()
        
        inputTypeButton.layer.cornerRadius = 10
        inputTypeButton.showsMenuAsPrimaryAction = true
        inputTypeButton.menu = colorInputTypeContextMenu()
        
        inputColor.layer.cornerRadius = 10
        inputColor.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        inputColor.leftViewMode = .always
        inputColor.delegate = self
        
        outputTypeButton.layer.cornerRadius = 10
        outputTypeButton.showsMenuAsPrimaryAction = true
        outputTypeButton.menu = colorOutputTypeContextMenu()

        outputColorView.layer.cornerRadius = 10
//        outputColorText.textColor = UIColor.lightGray
//        outputColorView.addSubview(outputColorText)

        mainStackBottomConstraint.constant = 130
    }
    override func viewWillAppear(_ animated: Bool) {
        reload()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: OBJC FUNCS
    @objc private func colorSelectorUpdate() {
//        GlobalColor.color = UIColor(hex: colorSelector.selectedColor!.hex)
        let comps = colorSelector.selectedColor!.cgColor.components!
        GlobalColor.color = UIColor(
            red: comps[0] < 0.001 ? 0 : comps[0],
            green: comps[1] < 0.001 ? 0 : comps[1],
            blue: comps[2] < 0.001 ? 0 : comps[2],
            alpha: 1)
        print(GlobalColor.color)
        
        setDefaultColor()
        backgroundView.backgroundColor = GlobalColor.color
        updateInputColorField()
        updateOutputColorField()
    }
    @objc func refresh (notification: NSNotification){ reload() }
    
    // MARK: FUNCS
    func reload() {
        updateElementColors()
        updateInputColorField()
        updateOutputColorField()
        reloadTypes()
        
        inputTypeButton.menu = colorInputTypeContextMenu()
        outputTypeButton.menu = colorOutputTypeContextMenu()
    }
    func colorInputTypeContextMenu() -> UIMenu {
        var actions: [UIAction] = []
        for type in ColorType.allCases {
            let name = type.rawValue.uppercased()
            actions.append(UIAction(title: name, state: GlobalColor.inputType == type ? .on : .off) { _ in
                GlobalColor.inputType = type
                self.updateInputColorField()
            })
        }
        actions.reverse()
        let colorInputTypeMenu = UIMenu(title: "Input Type", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: actions)
        return colorInputTypeMenu
    }
    
    func colorOutputTypeContextMenu() -> UIMenu {
        var actions: [UIAction] = []
        for type in ColorType.allCases {
            let name = type.rawValue.uppercased()
            actions.append(UIAction(title: name, state: GlobalColor.outputType == type ? .on : .off) { _ in
                GlobalColor.outputType = type
                self.updateOutputColorField()
            })
        }
        actions.reverse()
        let colorOutputTypeMenu = UIMenu(title: "Ouptut Type", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: actions)
        return colorOutputTypeMenu
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func updateInputColorField() {
        inputColor.text = colorToText(color: GlobalColor.color, type: GlobalColor.inputType)
        setDefaultInputType()
    }
    func updateOutputColorField() {
        outputColorText.text = colorToText(color: GlobalColor.color, type: GlobalColor.outputType)
        setDefaultOutputType()
    }
    /// Sets background color and color selector color to GlobalColor.color
    func updateElementColors() {
        backgroundView.backgroundColor = GlobalColor.color
        colorSelector.selectedColor = GlobalColor.color
    }
    func reloadTypes() {
        self.inputTypeButton.setTitle(GlobalColor.inputType.rawValue.uppercased(), for: .normal)
        self.outputTypeButton.setTitle(GlobalColor.outputType.rawValue.uppercased(), for: .normal)
    }
    // MARK: DEFAULTS
    func setDefaultColor() {
        defaults.set(GlobalColor.colorNS, forKey: "color")
    }
    func setDefaultInputType() {
        defaults.set(GlobalColor.inTypeNS, forKey: "inType")
    }
    func setDefaultOutputType() {
        defaults.set(GlobalColor.outTypeNS, forKey: "outType")
    }
}
