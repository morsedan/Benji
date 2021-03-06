//
//  ReservationViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 1/14/20.
//  Copyright © 2020 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TMROLocalization

enum OnboardingType {
    case existingUser
    case newUser
    case waitlist
    case login
}

class ReservationViewController: TextInputViewController<OnboardingType> {

    let button = Button()

    init() {
        let textField = TextField()
        let title = LocalizedString(id: "", arguments: [], default: "Enter your reservation code.")
        let placeholder = LocalizedString(id: "", arguments: [], default: "Code")

        super.init(textField: textField,
                   title: title,
                   placeholder: placeholder)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initializeViews() {
        super.initializeViews()

        self.textField.keyboardType = .default
        self.textField.autocorrectionType = .no
        self.textField.autocapitalizationType = .none

        self.view.addSubview(self.button)
        self.button.set(style: .rounded(color: .blue, text: "Login"))
        self.button.didSelect = {
            self.complete(with: .success(.login))
        }
    }

    override func shouldBecomeFirstResponder() -> Bool {
        return false
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.textEntry.bottom = self.view.height - 400

        self.button.size = CGSize(width: 200, height: 40)
        self.button.centerOnX()
        self.button.bottom = self.view.height - 50
        self.button.roundCorners()
    }

    override func textFieldDidEndEditing(_ textField: UITextField) {
        guard let code = textField.text, !code.isEmpty else { return }

        VerifyReservation(code: code)
            .makeRequest()
            .observe { (result) in
                switch result {
                case .success(let reservation):
                    //If a reservation has a user, then go to verify screen
                    if let _ = reservation.user {
                        self.complete(with: .success(.existingUser))
                    } else {
                        //If a reservation DOES NOT have a user then go to phone screen
                        self.complete(with: .success(.newUser))
                    }
                case .failure(let error):
                    //No reservation means join the waitlist
                    self.complete(with: .failure(error))
                }
        }
    }
}
