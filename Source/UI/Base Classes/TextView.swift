//
//  TextView.swift
//  Benji
//
//  Created by Benji Dodgson on 12/25/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

class TextView: UITextView {

    func set(attributed: AttributedString,
             alignment: NSTextAlignment = .left,
             lineCount: Int = 0,
             lineBreakMode: NSLineBreakMode = .byWordWrapping,
             stringCasing: StringCasing = .unchanged,
             isEditable: Bool = false,
             linkColor: Color = .white) {

        let string = stringCasing.format(string: attributed.string.string)
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttributes(attributed.attributes, range: NSRange(location: 0,
                                                                             length: attributedString.length))
        // NOTE: Some emojis don't display properly with certain attributes applied to them
        for emojiRange in string.getEmojiRanges() {
            attributedString.removeAttributes(atRange: emojiRange)
        }

        attributedString.linkItems()
        self.linkTextAttributes = [.foregroundColor: linkColor.color, .underlineStyle: 1]

        self.isEditable = isEditable
        self.attributedText = attributedString
        self.textContainer.maximumNumberOfLines = lineCount
        self.textContainer.lineBreakMode = lineBreakMode
        self.textAlignment = alignment
        self.isUserInteractionEnabled = true
        self.dataDetectorTypes = .all
        self.textContainerInset = .zero
        self.textContainer.lineFragmentPadding = 0
    }
}
