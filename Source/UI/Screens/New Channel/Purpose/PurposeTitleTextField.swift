//
//  PurposeTitleLabel.swift
//  Benji
//
//  Created by Benji Dodgson on 9/8/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class PurposeTitleTextField: TextField {

    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

    override func initialize() {
        super.initialize()

        self.returnKeyType = .done
        self.autocapitalizationType = .none

        let attributed = AttributedString("", fontType: .smallBold, color: .background4)
        self.setPlaceholder(attributed: attributed)
        self.setDefaultAttributes(style: StringStyle(font: .smallBold, color: .white))

        self.setDefault()
    }

    private func setDefault() {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEEMMdd"

        self.text = formatter.string(from: Date()).lowercased()
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.padding)
    }
}
