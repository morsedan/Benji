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
import TMROLocalization

protocol LoginCodeViewControllerDelegate: class {
    func loginCodeView(_ controller: LoginCodeViewController, didVerify user: PFUser)
}

class LoginCodeViewController: LoginTextInputViewController {

    var phoneNumber: PhoneNumber?

    unowned let delegate: LoginCodeViewControllerDelegate

    init(with delegate: LoginCodeViewControllerDelegate) {
        self.delegate = delegate
        super.init(textField: TextField(),
                   textFieldTitle: LocalizedString(id: "", default: "CODE"),
                   textFieldPlaceholder: LocalizedString(id: "", default: "0000"))
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func textFieldDidChange() {
        guard let code = self.textField.text, code.extraWhitespaceRemoved().count == 4 else { return }
        self.verify(code: code)
    }

    // True if we're in the process of verifying the code
    var verifying: Bool = false
    private func verify(code: String) {
        guard !self.verifying, let phoneNumber = self.phoneNumber else { return }

        self.verifying = true

        let tf = self.textField as? TextField
        tf?.activityIndicator.startAnimating()
        VerifyCode(code: code, phoneNumber: phoneNumber).callFunction { (object, error) in
            if let token = object as? String {
                User.become(inBackground: token) { (user, error) in
                    if let strongUser = user {
                        self.delegate.loginCodeView(self, didVerify: strongUser)
                    }
                    tf?.activityIndicator.stopAnimating()
                }
            }
            self.textField.resignFirstResponder()
        }
    }

    override func getAccessoryText() -> Localized? {
        return LocalizedString(id: "", arguments: [], default: "Enter the 4 digit code from the text message.")
    }
}
