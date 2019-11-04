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

protocol LoginCodeViewControllerDelegate: class {
    func loginCodeView(_ controller: LoginCodeViewController, didVerify user: PFUser)
}

class LoginCodeViewController: LoginTextInputViewController {

    let phoneNumber: PhoneNumber

    unowned let delegate: LoginCodeViewControllerDelegate

    init(with delegate: LoginCodeViewControllerDelegate, phoneNumber: PhoneNumber) {
        self.delegate = delegate
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

        let tf = self.textField as? TextField
        tf?.activityIndicator.startAnimating()
        //Temp
        User.current()?.phoneNumber = self.phoneNumber.numberString.formatPhoneNumber()
        User.current()?.saveObject()
            .observe { (result) in
                switch result {
                case .success(let user):
                    self.delegate.loginCodeView(self, didVerify: user)
                case .failure(_):
                    break 
                }
                tf?.activityIndicator.stopAnimating()
                self.textField.resignFirstResponder()
        }

//        VerifyCode.callFunction { (object, error) in
//            if let user = object as? PFUser {
//                self.delegate.loginCodeView(self, didVerify: user)
//            }
//            self.textField.resignFirstResponder()
//        }
    }
}
