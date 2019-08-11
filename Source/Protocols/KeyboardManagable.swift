//
//  KeyboardManagable.swift
//  Benji
//
//  Created by Benji Dodgson on 8/11/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

protocol KeyboardManageable: NSObjectProtocol {
    func handleKeyboard(height: CGFloat)
}

private var keyboardOffsetKey: UInt8 = 0
private var keyboardHandlerKey: UInt8 = 0
extension KeyboardManageable where Self: ViewController {

    var offset: CGFloat {
        get {
            return self.getAssociatedObject(&keyboardOffsetKey) ?? 0
        }
        set {
            self.setAssociatedObject(key: &keyboardOffsetKey, value: newValue)
        }
    }

    private var keyboardHandler: KeyboardHandler? {
        get {
            return self.getAssociatedObject(&keyboardHandlerKey)
        }
        set {
            self.setAssociatedObject(key: &keyboardHandlerKey, value: newValue)
        }
    }

    func registerKeyboardEvents() {
        // Disable when the keyboard is shown
        let handler = KeyboardHandler(with: self)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handler.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handler.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        self.keyboardHandler = handler
    }
}

private class KeyboardHandler: NSObject {

    unowned let vc: ViewController & KeyboardManageable

    init(with vc: ViewController & KeyboardManageable) {
        self.vc = vc
        super.init()
    }

    @objc func keyboardWillShow(notification: Notification) {
        // self.isEnabled = false
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame: NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        self.vc.handleKeyboard(height: keyboardHeight)
    }

    @objc func keyboardWillHide(notification: Notification) {
        self.vc.handleKeyboard(height: .zero)
    }
}
