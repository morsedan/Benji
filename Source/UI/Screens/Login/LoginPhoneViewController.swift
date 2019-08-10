//
//  LoginPhoneViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 8/10/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import PhoneNumberKit

class LoginPhoneViewController: LoginTextInputViewController {

    var didComplete: (_ phone: PhoneNumber?) -> Void = { _ in }

    init() {
        let phoneField = PhoneNumberTextField(frame: CGRect.zero, phoneNumberKit: PhoneKit.shared)

        super.init(textField: phoneField,
                   textFieldTitle: TomorrowString(id: "", default: "MOBILE NUMBER"),
                   textFieldPlaceholder: TomorrowString(id: "",
                                                        default: "000-000-0000"))

        phoneField.defaultRegion = TomorrowTheme.defaultRegion
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initializeViews() {
        super.initializeViews()

        self.textField.autocorrectionType = .yes
        self.textField.textContentType = .telephoneNumber

        self.textField.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)

        let termsTitle = TomorrowString(id: "panel.loginphone.tos",
                                        default: "I AGREE TO TOMORROW'S TERMS OF SERVICE & PRIVACY POLICY")
        self.termsCheckbox.config(localizedTitle: termsTitle,
                                  backgroundColor: TomorrowColor.blue2,
                                  checkedStatus: CheckStatus.getStatus(isChecked: self.agreedToTerms, isLocked: false))
        self.termsCheckbox.delegate = self
        self.view.addSubview(self.termsCheckbox)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.termsCheckbox.size = CGSize(width: self.textField.width, height: 44)
        self.termsCheckbox.left = self.textField.left - 12
        self.termsCheckbox.top = self.textField.bottom + 5
    }

    override func textFieldDidChange() {
        if self.isPhoneNumberValid() {
            // End editing because we have a valid phone number and we're ready to request a code with it
            self.textField.resignFirstResponder()
        }
    }

    @objc func editingDidEnd() {
        guard self.agreedToTerms,
            let text = self.textField.text,
            text.isValidPhoneNumber(),
            let phone = try? PhoneKit.shared.parse(text, withRegion: TomorrowTheme.defaultRegion) else {
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
        SendCode(phone: phone)
            .producer
            .withErrorBanner()
            .on(completed: { [weak self] in
                guard let self = `self` else { return }
                self.didComplete(phone)
            })
            .start()
    }
}
