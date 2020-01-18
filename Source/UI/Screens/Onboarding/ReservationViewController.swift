//
//  ReservationViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 1/14/20.
//  Copyright © 2020 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TMROLocalization

class ReservationViewController: TextInputViewController<Void> {

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
}
