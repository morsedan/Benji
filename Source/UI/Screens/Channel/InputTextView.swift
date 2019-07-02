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

        self.minHeight = 48
        self.set(placeholder: "Message...")

        self.layer.masksToBounds = true
        self.layer.borderColor = Color.white.color.cgColor
        self.layer.borderWidth = Theme.borderWidth
    }

    func set(placeholder: Localized) {
        let styleAttributes = StringStyle(font: .regularSemiBold, color: .lightPurple, kern: 0).attributes
        let string = NSAttributedString(string: localized(placeholder), attributes: styleAttributes)
        self.attributedPlaceholder = string
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.cornerRadius = self.halfHeight
    }
}
