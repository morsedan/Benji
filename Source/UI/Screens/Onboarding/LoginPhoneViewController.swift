//
//  LoginPhoneViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 8/10/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import PhoneNumberKit
import Parse
import TMROLocalization

protocol LoginPhoneViewControllerDelegate: class {
    func loginPhoneView(_ controller: LoginPhoneViewController, didCompleteWith phone: PhoneNumber)
}

class LoginPhoneViewController: TextInputViewController {

    unowned let delegate: LoginPhoneViewControllerDelegate

    init(with delegate: LoginPhoneViewControllerDelegate) {
        self.delegate = delegate
        let phoneField = PhoneNumberTextField.init()

        super.init(textField: phoneField,
                   textFieldTitle: LocalizedString(id: "", default: "MOBILE NUMBER"),
                   textFieldPlaceholder: LocalizedString(id: "", default: "000-000-0000"))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initializeViews() {
        super.initializeViews()

        self.textField.autocorrectionType = .yes
        self.textField.textContentType = .telephoneNumber

        self.textField.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
    }

    override func textFieldDidChange() {
        if self.isPhoneNumberValid() {
            // End editing because we have a valid phone number and we're ready to request a code with it
            self.textField.resignFirstResponder()
        }
    }

    @objc func editingDidEnd() {
        guard let text = self.textField.text,
            text.isValidPhoneNumber(),
            let phone = try? PhoneKit.shared.parse(text, withRegion: "US") else {
                return
        }
        self.sendCode(to: phone)
    }

    private func isPhoneNumberValid() -> Bool {
        if let phoneString = self.textField.text, phoneString.isValidPhoneNumber() {
            return true
        }
        return false
    }

    private func sendCode(to phone: PhoneNumber) {
        // TODO: Add loading
        SendCode(phoneNumber: phone).callFunction { (object, error) in
            if error == nil {
                self.delegate.loginPhoneView(self, didCompleteWith: phone)
            }
            self.completeWithResult()
        }
    }

    override func getAccessoryText() -> Localized? {
        return LocalizedString(id: "", arguments: [], default: "Please verify your account using the mobile number for this device.")
    }
}

