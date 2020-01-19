//
//  LoginTextInputViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 8/10/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import ReactiveSwift
import TMROLocalization

class TextInputViewController<ResultType>: ViewController, Sizeable, Completable, UITextFieldDelegate, KeyboardObservable {

    var onDidComplete: ((Result<ResultType, Error>) -> Void)?

    let textField: UITextField
    lazy var textInputAccessory = TextInputAccessoryView()
    private let textEntry: TextEntryField

    init(textField: UITextField,
         title: Localized,
         placeholder: Localized?) {

        self.textField = textField

        self.textEntry = TextEntryField(with: textField,
                                        title: title,
                                        placeholder: placeholder)
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initializeViews() {
        super.initializeViews()

        self.view.set(backgroundColor: .background1)
        self.view.addSubview(self.textEntry)

        self.textField.keyboardType = .numberPad

        self.textField.addTarget(self,
                                 action: #selector(textFieldDidChange),
                                 for: UIControl.Event.editingChanged)
        self.textField.delegate = self
        self.registerKeyboardEvents()
    }

    @objc func textFieldDidChange() {}

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard let handler = self.keyboardHandler else { return }

        let width = self.view.width - (Theme.contentOffset * 2)
        let height = self.textEntry.getHeight(for: width)
        self.textEntry.size = CGSize(width: width, height: height)
        self.textEntry.centerOnX()

        let defaultOffset = self.view.height - 30
        self.textEntry.bottom = defaultOffset - handler.currentKeyboardHeight
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.textField.becomeFirstResponder()
    }

    func getAccessoryText() -> Localized? {
        return nil
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {}

    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let text = self.getAccessoryText(), !localized(text).isEmpty else { return }
        self.showAccessory()
    }

    func showAccessory() {
        self.textField.inputAccessoryView = nil
        self.textField.reloadInputViews()

        self.textInputAccessory.frame = CGRect(x: 0,
                                               y: 0,
                                               width: UIScreen.main.bounds.width,
                                               height: 60)
        self.textInputAccessory.keyboardAppearance = self.textField.keyboardAppearance
        self.textInputAccessory.text = self.getAccessoryText()
        self.textField.inputAccessoryView = self.textInputAccessory
        self.textField.reloadInputViews()

        self.textInputAccessory.didCancel = { [unowned self] in
            self.textField.resignFirstResponder()
        }
    }

    func handleKeyboard(frame: CGRect, with animationDuration: TimeInterval, timingCurve: UIView.AnimationCurve) {
        guard let handler = self.keyboardHandler, handler.currentKeyboardHeight > 0 else { return }

        UIView.animate(withDuration: animationDuration) {
            self.view.layoutNow()
        }
    }
}

