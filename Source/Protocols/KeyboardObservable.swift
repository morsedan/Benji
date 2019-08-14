//
//  KeyboardManagable.swift
//  Benji
//
//  Created by Benji Dodgson on 8/11/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

enum KeyboardState {
    case willShow(height: CGFloat)
    case didShow(height: CGFloat)
    case willHide(height: CGFloat)
    case didHide(height: CGFloat)
}

protocol KeyboardObservable: NSObjectProtocol {
    func handleKeyboard(state: KeyboardState, with animationDuration: TimeInterval)
}

private var keyboardHandlerKey: UInt8 = 0
extension KeyboardObservable where Self: ViewController {

    private(set) var keyboardHandler: KeyboardHandler? {
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
        self.keyboardHandler = handler

        NotificationCenter.default.addObserver(handler,
                                               selector: #selector(handler.keyboardWillHandle),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(handler,
                                               selector: #selector(handler.keyboardWillHandle),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(handler,
                                               selector: #selector(handler.keyboardWillHandle),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(handler,
                                               selector: #selector(handler.keyboardWillHandle),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
    }
}

class KeyboardHandler: NSObject {

    unowned let vc: ViewController & KeyboardObservable

    private(set) var currentKeyboardHeight: CGFloat = 0

    init(with vc: ViewController & KeyboardObservable) {
        self.vc = vc
        super.init()
    }

    @objc func keyboardWillHandle(notification: Notification) {
        guard let size = notification.keyboardSize,
            let animationDuration = notification.keyboardAnimationDuration else { return }
        
        if size.height != self.currentKeyboardHeight {
            switch notification.name {
            case UIResponder.keyboardWillShowNotification:
                self.vc.handleKeyboard(state: .willShow(height: size.height), with: animationDuration)
            case UIResponder.keyboardWillHideNotification:
                self.vc.handleKeyboard(state: .willHide(height: size.height), with: animationDuration)
            case UIResponder.keyboardDidHideNotification:
                self.vc.handleKeyboard(state: .didHide(height: size.height), with: animationDuration)
            case UIResponder.keyboardDidShowNotification:
                self.vc.handleKeyboard(state: .didShow(height: size.height), with: animationDuration)
            default:
                break
            }
        }

        self.currentKeyboardHeight = size.height
    }
}

extension Notification {

    var keyboardSize: CGSize? {
        return (self.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
    }
    var keyboardAnimationDuration: Double? {
        return self.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
    }
}
