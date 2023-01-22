//
//  CopyableLabel.swift
//
//  Created by Stephen Radford on 08/09/2015.
//  Adapted by Will Conrad on 01/22/2023
//

import UIKit

class CopyableLabel: UILabel, UIEditMenuInteractionDelegate {
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }

    func sharedInit() {
        isUserInteractionEnabled = true
        addGestureRecognizer(UILongPressGestureRecognizer(
            target: self,
            action: #selector(showMenu)
        ))
    }

    @objc private func showMenu(_ sender: UILongPressGestureRecognizer) {
        let menu = UIEditMenuInteraction(delegate: self)
        let location = sender.location(in: self)
        self.addInteraction(menu)
        
        if sender.state == .began {
            menu.presentEditMenu(with: UIEditMenuConfiguration(identifier: nil, sourcePoint: location))
        }
    }
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return (action == #selector(copy(_:)))
    }
    override func copy(_ sender: Any?) {
        UIPasteboard.general.string = text

    }
}
