//
//  MessageTextView.swift
//  Benji
//
//  Created by Benji Dodgson on 7/1/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class MessageTextView: TextView {

    static let contentInset: CGFloat = 14

    override func initialize() {
        super.initialize()

        self.isEditable = false
        self.isScrollEnabled = false
        self.isSelectable = true

        self.textContainerInset.top = MessageTextView.contentInset
        self.textContainerInset.bottom = MessageTextView.contentInset
        self.textContainerInset.right = MessageTextView.contentInset
        self.textContainerInset.left = MessageTextView.contentInset
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
