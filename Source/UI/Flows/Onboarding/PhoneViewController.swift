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
import TMROFutures

class PhoneViewController: TextInputViewController<PhoneNumber> {

    init() {
        let phoneField = PhoneTextField()
        super.init(textField: phoneField,
                   title: LocalizedString(id: "", default: "MOBILE NUMBER"),
                   placeholder: LocalizedString(id: "", default: "000-000-0000"))
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
        SendCode(phoneNumber: phone).makeRequest()
            .withResultToast()
            .observe(with: { (result) in
                switch result {
                case .success:
                    self.complete(with: .success(phone))
                case .failure(let error):
                    self.complete(with: .failure(error))
                }
            })
    }
}

