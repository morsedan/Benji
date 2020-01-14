//
//  ReservationViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 1/14/20.
//  Copyright © 2020 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TMROLocalization

class ReservationViewController: LoginTextInputViewController {

    init() {
        let textField = TextField()
        let title = LocalizedString(id: "", arguments: [], default: "Enter your reservation code.")
        let placeholder = LocalizedString(id: "", arguments: [], default: "Code")
        super.init(textField: textField, textFieldTitle: title, textFieldPlaceholder: placeholder)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func getAccessoryText() -> Localized? {
        return ""
    }
}
