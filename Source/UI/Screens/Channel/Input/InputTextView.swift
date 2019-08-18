//
//  InputTextView.swift
//  Benji
//
//  Created by Benji Dodgson on 7/2/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class InputTextView: GrowingTextView {

    override func initialize() {
        super.initialize()

        self.set(placeholder: "Message...")

        self.textContainerInset.left = 16
        self.textContainerInset.right = 16
        self.textContainerInset.top = 14
        self.textContainerInset.bottom = 14

        self.set(backgroundColor: .backgroundWithAlpha)
    }

    func set(placeholder: Localized) {
        let styleAttributes = StringStyle(font: .regularSemiBold, color: .lightPurple).attributes
        let string = NSAttributedString(string: localized(placeholder), attributes: styleAttributes)
        self.attributedPlaceholder = string
    }
}
