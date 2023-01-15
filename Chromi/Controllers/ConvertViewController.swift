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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    
    @IBAction func inputColorUpdated(_ sender: Any) {
        if let color = parseInputColor(color: inputColor.text!, type: GlobalColor.inputType) {
            GlobalColor.color = color
        }
        self.updateElementColors()
        self.updateOutputColorField()
    }
    
    func colorInputTypeContextMenu() -> UIMenu {
        let rgbIn = UIAction(title: "RGB", state: GlobalColor.inputType == .rgb ? .on : .off) { _ in
            print("RGB")
            self.inputTypeButton.setTitle("RGB", for: .normal)
            GlobalColor.inputType = .rgb
            self.updateInputColorField()
        }
        let hslIn = UIAction(title: "HSL", state: GlobalColor.inputType == .hsl ? .on : .off) { _ in
            print("HSL")
            self.inputTypeButton.setTitle("HSL", for: .normal)
            GlobalColor.inputType = .hsl
            self.updateInputColorField()
        }
        let hsvIn = UIAction(title: "HSV", state: GlobalColor.inputType == .hsv ? .on : .off) { _ in
            print("HSV")
            self.inputTypeButton.setTitle("HSV", for: .normal)
            GlobalColor.inputType = .hsv
            self.updateInputColorField()
        }
        let cmykIn = UIAction(title: "CMYK", state: GlobalColor.inputType == .cmyk ? .on : .off) { _ in
            print("CMYK")
            self.inputTypeButton.setTitle("CMYK", for: .normal)
            GlobalColor.inputType = .cmyk
            self.updateInputColorField()
        }
        let hexIn = UIAction(title: "HEX", state: GlobalColor.inputType == .hex ? .on : .off) { _ in
            print("HEX")
            self.inputTypeButton.setTitle("HEX", for: .normal)
            GlobalColor.inputType = .hex
            self.updateInputColorField()
        }
        let colorInputTypeMenu = UIMenu(title: "Input Type", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [rgbIn, hslIn, hsvIn, cmykIn, hexIn])
        return colorInputTypeMenu
    }
    
    func colorOutputTypeContextMenu() -> UIMenu {
        let rgbOut = UIAction(title: "RGB", state: GlobalColor.outputType == .rgb ? .on : .off) { _ in
            print("RGB")
            self.outputTypeButton.setTitle("RGB", for: .normal)
            GlobalColor.outputType = .rgb
            self.updateOutputColorField()
        }
        let hslOut = UIAction(title: "HSL", state: GlobalColor.outputType == .hsl ? .on : .off) { _ in
            print("HSL")
            self.outputTypeButton.setTitle("HSL", for: .normal)
            GlobalColor.outputType = .hsl
            self.updateOutputColorField()
        }
        let hsvOut = UIAction(title: "HSV", state: GlobalColor.outputType == .hsv ? .on : .off) { _ in
            print("HSV")
            self.outputTypeButton.setTitle("HSV", for: .normal)
            GlobalColor.outputType = .hsv
            self.updateOutputColorField()
        }
        let cmykOut = UIAction(title: "CMYK", state: GlobalColor.outputType == .cmyk ? .on : .off) { _ in
            print("CMYK")
            self.outputTypeButton.setTitle("CMYK", for: .normal)
            GlobalColor.outputType = .cmyk
            self.updateOutputColorField()
        }
        let hexOut = UIAction(title: "HEX", state: GlobalColor.outputType == .hex ? .on : .off) { _ in
            print("HEX")
            self.outputTypeButton.setTitle("HEX", for: .normal)
            GlobalColor.outputType = .hex
            self.updateOutputColorField()
        }
        let colorOutputTypeMenu = UIMenu(title: "Ouptut Type", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [rgbOut, hslOut, hsvOut, cmykOut, hexOut])
        return colorOutputTypeMenu
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        inputColor.delegate = self
        
        inputTypeButton.layer.cornerRadius = 10
        outputTypeButton.layer.cornerRadius = 10
        inputColor.layer.cornerRadius = 10
        outputColorView.layer.cornerRadius = 10
        //mainStack.layer.cornerRadius = 10
        
        inputColor.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        inputColor.leftViewMode = .always
        
        self.inputTypeButton.setTitle("RGB", for: .normal)
        self.outputTypeButton.setTitle("HEX", for: .normal)
        
        self.outputColorText.text = ""
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

    @objc private func colorSelectorUpdate() {
        GlobalColor.color = colorSelector.selectedColor!
        backgroundView.backgroundColor = colorSelector.selectedColor
        updateInputColorField()
        updateOutputColorField()
    }
    
    func updateInputColorField() {
        inputColor.text = colorToText(color: GlobalColor.color, type: GlobalColor.inputType)
    }
    func updateOutputColorField() {
        outputColorText.text = colorToText(color: GlobalColor.color, type: GlobalColor.outputType)
    }
    func updateElementColors() {
        colorSelector.selectedColor = GlobalColor.color
        backgroundView.backgroundColor = GlobalColor.color
    }

    
    
   
    
}
