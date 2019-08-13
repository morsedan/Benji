//
//  LoginNameViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 8/12/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse

class LoginNameViewController: LoginTextInputViewController {

    var didAddName: () -> Void = {}

    private let doneButton = LoadingButton()

    init() {
        super.init(textField: TextField(),
                   textFieldTitle: LocalizedString(id: "", default: "NAME"),
                   textFieldPlaceholder: LocalizedString(id: "", default: "FIRST LAST"))
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initializeViews() {
        super.initializeViews()

        self.view.addSubview(self.doneButton)
        self.doneButton.set(style: .rounded(color: .blue, text: "DONE"))
        self.doneButton.onTap { [unowned self] (tap) in
            self.updateUserName()
        }

        self.textField.autocapitalizationType = .words
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.doneButton.size = CGSize(width: self.view.width * 0.8, height: 40)
        self.doneButton.top = self.textField.bottom + 40
        self.doneButton.centerOnX()
    }

    override func textFieldDidEndEditing(_ textField: UITextField) {
        super.textFieldDidEndEditing(textField)
        self.updateUserName()
    }

    private func updateUserName() {
        guard let current = PFUser.current(),
            let text = self.textField.text,
            !text.isEmpty else { return }

        current.firstName = text
        current.saveInBackground { (success, error) in
            guard success else { return }
            self.textField.resignFirstResponder()
            self.didAddName()
        }

        self.resignFirstResponder()
    }
}
