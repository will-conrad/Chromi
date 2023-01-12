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
    @IBOutlet var outputTypeView: UIView!
    
    @IBOutlet var inputColor: UITextField!
    
    @IBOutlet var outputColorView: UIView!
    
    var inputTypeText = ""
    var outputTypeText = UILabel(frame: CGRect(x: 10, y: 0, width: 88, height: 44))
    var outputColorText = UILabel(frame: CGRect(x: 10, y: 0, width: 170, height: 44))
    
    var inputType: ColorType = .rgb
    var outputType: ColorType = .hex
    
    
    
    var color: UIColor = .purple
    

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    
    @IBAction func inputColorUpdated(_ sender: Any) {
        if let color = parseInputColor(color: inputColor.text!, type: inputType) {
            self.color = color
        }
        self.updateElementColors()
        self.updateOutputColorField()
    }
    
    func colorInputTypeContextMenu() -> UIMenu {
        let rgbIn = UIAction(title: "RGB", state: inputType == .rgb ? .on : .off) { _ in
            print("RGB")
            self.inputTypeButton.setTitle("RGB", for: .normal)
            self.inputType = .rgb
            self.updateInputColorField()
        }
        let hslIn = UIAction(title: "HSL", state: inputType == .hsl ? .on : .off) { _ in
            print("HSL")
            self.inputTypeButton.setTitle("HSL", for: .normal)
            self.inputType = .hsl
            print(self.inputType)
            self.updateInputColorField()
        }
        let hsvIn = UIAction(title: "HSV", state: inputType == .hsv ? .on : .off) { _ in
            print("HSV")
            self.inputTypeButton.setTitle("HSV", for: .normal)
            self.inputType = .hsv
            self.updateInputColorField()
        }
        let cmykIn = UIAction(title: "CMYK", state: inputType == .cmyk ? .on : .off) { _ in
            print("CMYK")
            self.inputTypeButton.setTitle("CMYK", for: .normal)
            self.inputType = .cmyk
            self.updateInputColorField()
        }
        let hexIn = UIAction(title: "HEX", state: inputType == .hex ? .on : .off) { _ in
            print("HEX")
            self.inputTypeButton.setTitle("HEX", for: .normal)
            self.inputType = .hex
            self.updateInputColorField()
        }
        let colorInputTypeMenu = UIMenu(title: "Input Type", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [rgbIn, hslIn, hsvIn, cmykIn, hexIn])
        return colorInputTypeMenu
    }
    
    func colorOutputTypeContextMenu() -> UIMenu {
        let rgbOut = UIAction(title: "RGB", state: outputType == .rgb ? .on : .off) { _ in
            print("RGB")
            self.outputTypeText.text = "RGB"
            self.outputType = .rgb
            self.updateOutputColorField()
        }
        let hslOut = UIAction(title: "HSL", state: outputType == .hsl ? .on : .off) { _ in
            print("HSL")
            self.outputTypeText.text = "HSL"
            self.outputType = .hsl
            self.updateOutputColorField()
        }
        let hsvOut = UIAction(title: "HSV", state: outputType == .hsv ? .on : .off) { _ in
            print("HSV")
            self.outputTypeText.text = "HSV"
            self.outputType = .hsv
            self.updateOutputColorField()
        }
        let cmykOut = UIAction(title: "CMYK", state: outputType == .cmyk ? .on : .off) { _ in
            print("CMYK")
            self.outputTypeText.text = "CMYK"
            self.outputType = .cmyk
            self.updateOutputColorField()
        }
        let hexOut = UIAction(title: "HEX", state: outputType == .hex ? .on : .off) { _ in
            print("HEX")
            self.outputTypeText.text = "HEX"
            self.outputType = .hex
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
        outputTypeView.layer.cornerRadius = 10
        inputColor.layer.cornerRadius = 10
        outputColorView.layer.cornerRadius = 10
        mainStack.layer.cornerRadius = 10
        
        inputColor.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        inputColor.leftViewMode = .always
        
        self.inputTypeText = "RGB"
        inputTypeButton.setTitle(self.inputTypeText, for: .normal)
        
        self.outputTypeText.text = "HEX"
        outputTypeView.addSubview(outputTypeText)
        
        self.outputColorText.text = ""
        self.outputColorText.textColor = UIColor.lightGray
        outputColorView.addSubview(outputColorText)

        //Add interactions to views, save pointers to compare when showing menus

        inputTypeButton.showsMenuAsPrimaryAction = true
        inputTypeButton.menu = colorInputTypeContextMenu()

        colorSelector.addTarget(self, action: #selector(colorSelectorUpdate), for: .valueChanged)
        colorSelector.selectedColor = self.color
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
    
    @IBAction func copyToClipboard(_ sender: Any) {
        UIPasteboard.general.string = outputColorText.text
    }
    @objc private func colorSelectorUpdate() {
        self.color = colorSelector.selectedColor!
        backgroundView.backgroundColor = colorSelector.selectedColor
        updateInputColorField()
        updateOutputColorField()
        
    }
    func updateInputColorField() {
        inputColor.text = colorToText(color: self.color, type: inputType)
    }
    func updateOutputColorField() {
        outputColorText.text = colorToText(color: self.color, type: outputType)
        GlobalColor.color = self.color
    }
    func updateElementColors() {
        colorSelector.selectedColor = self.color
        backgroundView.backgroundColor = self.color
    }

    
    
   
    
}
