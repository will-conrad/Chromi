//
//  ConvertViewController.swift
//  Chromi
//
//  Created by Will Conrad on 1/11/23.
//

import UIKit

class ConvertViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var mainStackBottomConstraint: NSLayoutConstraint!
    @IBOutlet var mainStack: UITableView!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var colorSelector: UIColorWell!
    @IBOutlet var inputTypeButton: UIButton!
    @IBOutlet var inputColor: UITextField!
    @IBOutlet var outputTypeButton: UIButton!
    @IBOutlet var outputColorView: UIView!

    var outputColorText = SRCopyableLabel(frame: CGRect(x: 10, y: 0, width: 200, height: 44))
    
    let types: [ColorType] = [.rgb, .hsl, .hsv, .cmyk, .hex]
    
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
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        inputColor.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.Name("reload"), object: nil)

        inputTypeButton.layer.cornerRadius = 10
        outputTypeButton.layer.cornerRadius = 10
        inputColor.layer.cornerRadius = 10
        outputColorView.layer.cornerRadius = 10
        
        inputColor.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        inputColor.leftViewMode = .always
        
        self.outputColorText.textColor = UIColor.lightGray
        outputColorView.addSubview(outputColorText)

        inputTypeButton.showsMenuAsPrimaryAction = true
        inputTypeButton.menu = colorInputTypeContextMenu()
        outputTypeButton.showsMenuAsPrimaryAction = true
        outputTypeButton.menu = colorOutputTypeContextMenu()

        colorSelector.addTarget(self, action: #selector(colorSelectorUpdate), for: .valueChanged)
        colorSelector.selectedColor = GlobalColor.color
        
        colorSelectorUpdate()
        
        mainStackBottomConstraint.constant = 130
    }
    override func viewWillAppear(_ animated: Bool) {
        reset()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: OBJC FUNCS
    @objc private func colorSelectorUpdate() {
        GlobalColor.color = colorSelector.selectedColor!
        setDefaultColor()
        backgroundView.backgroundColor = colorSelector.selectedColor
        updateInputColorField()
        updateOutputColorField()
    }
    @objc func reload (notification: NSNotification){ //add stuff here}
        reset()
    }
    // MARK: FUNCS
    func reset() {
        updateElementColors()
        reloadTypes()
        updateInputColorField()
        updateOutputColorField()
    }
    
    func colorInputTypeContextMenu() -> UIMenu {
        var actions: [UIAction] = []
        for type in types {
            let name = type.rawValue.uppercased()
            actions.append(UIAction(
                title: name, state: GlobalColor.inputType == type ? .on : .off) { _ in
                    self.inputTypeButton.setTitle(name, for: .normal)
                GlobalColor.inputType = type
                self.updateInputColorField()
            })
        }
        let colorInputTypeMenu = UIMenu(title: "Input Type", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: actions)
        return colorInputTypeMenu
    }
    
    func colorOutputTypeContextMenu() -> UIMenu {
        var actions: [UIAction] = []
        for type in types {
            let name = type.rawValue.uppercased()
            actions.append(UIAction(
                title: name, state: GlobalColor.outputType == type ? .on : .off) { _ in
                    self.outputTypeButton.setTitle(name, for: .normal)
                GlobalColor.outputType = type
                self.updateOutputColorField()
            })
        }
        let colorOutputTypeMenu = UIMenu(title: "Ouptut Type", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: actions)
        return colorOutputTypeMenu
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func updateInputColorField() {
        print(GlobalColor.color)
        inputColor.text = colorToText(color: GlobalColor.color, type: GlobalColor.inputType)
        setDefaultInputType()
    }
    func updateOutputColorField() {
        outputColorText.text = colorToText(color: GlobalColor.color, type: GlobalColor.outputType)
        setDefaultOutputType()
    }
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
        UserDefaults.standard.set(GlobalColor.colorNS, forKey: "color")
    }
    func setDefaultInputType() {
        UserDefaults.standard.set(GlobalColor.inTypeNS, forKey: "inType")
    }
    func setDefaultOutputType() {
        UserDefaults.standard.set(GlobalColor.outTypeNS, forKey: "outType")
    }
}
