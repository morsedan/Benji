//
//  LoginNameViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 8/12/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse
import TMROLocalization

protocol LoginNameViewControllerDelegate: class {
    func loginNameViewControllerDidComplete(_ controller: LoginNameViewController)
}

class LoginNameViewController: TextInputViewController<Void> {

    unowned let delegate: LoginNameViewControllerDelegate

    init(with delegate: LoginNameViewControllerDelegate) {

        self.delegate = delegate
        super.init(textField: TextField(),
                   textFieldTitle: LocalizedString(id: "", default: "FULL NAME"),
                   textFieldPlaceholder: LocalizedString(id: "", default: "First Last"))
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initializeViews() {
        super.initializeViews()

        self.textField.autocapitalizationType = .words
        self.textField.keyboardType = .default
        self.textField.textContentType = .name
        self.textField.enablesReturnKeyAutomatically = true
    }

    override func textFieldDidEndEditing(_ textField: UITextField) {
        self.updateUserName()
    }

    private func updateUserName() {
        guard let text = self.textField.text,
            !text.isEmpty else { return }

        let tf = self.textField as? TextField
        tf?.activityIndicator.startAnimating()

        User.current()?.formatName(from: text)
        User.current()?.saveEventually()
            .observe { (result) in
                tf?.activityIndicator.stopAnimating()
                self.delegate.loginNameViewControllerDidComplete(self)
        }
    }

    override func getAccessoryText() -> Localized? {
        return LocalizedString(id: "", arguments: [], default: "Please use your legal first and last name.")
    }
}
