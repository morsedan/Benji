//
//  MessageTextView.swift
//  Benji
//
//  Created by Benji Dodgson on 7/1/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class MessageTextView: TextView {

    override func initialize() {
        super.initialize()

        self.isEditable = false
        self.isScrollEnabled = false
        self.isSelectable = true
    }

    func set(text: Localized) {
        let textColor: Color  = .white

        let attributedString = AttributedString(text,
                                                fontType: .regular,
                                                color: textColor,
                                                kern: 0)

        self.set(attributed: attributedString,
                 alignment: .left,
                 lineCount: 0,
                 lineBreakMode: .byWordWrapping,
                 stringCasing: .unchanged,
                 isEditable: false,
                 linkColor: textColor)
    }
}
