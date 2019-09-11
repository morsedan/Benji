//
//  LoginCodeViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 8/10/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import PhoneNumberKit
import ReactiveSwift
import Parse

class LoginCodeViewController: LoginTextInputViewController {

    var didVerifyUser: (_ user: PFUser) -> Void = { _ in }
    let phoneNumber: PhoneNumber

    init(phoneNumber: PhoneNumber) {
        self.phoneNumber = phoneNumber
        super.init(textField: TextField(),
                   textFieldTitle: LocalizedString(id: "", default: "CODE"),
                   textFieldPlaceholder: LocalizedString(id: "", default: "000000"))
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func textFieldDidChange() {
        guard let code = self.textField.text, code.extraWhitespaceRemoved().count == 6 else { return }
        self.verify(code: code)
    }

    // True if we're in the process of verifying the code
    var verifying: Bool = false
    private func verify(code: String) {
        guard !self.verifying else { return }

        self.verifying = true

        guard let current = PFUser.current() else { return }
        current.phoneNumber = self.phoneNumber.numberString.formatPhoneNumber()
        current.saveInBackground { (completed, error) in
            if completed {
                self.didVerifyUser(current)
            }
        }

        VerifyCode.callFunction { (object, error) in
            if let user = object as? PFUser {
                self.didVerifyUser(user)
            }
            self.textField.resignFirstResponder()
        }
    }
}
