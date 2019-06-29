//
//  ChannelCell.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient

class MessageCell: UICollectionViewCell, DisplayableCell {
    typealias ItemType = TCHMessage
    static let offset: CGFloat = 10

    let textView = TextView()
    let bubbleView = View()

    func configure(with item: TCHMessage?) {
        guard let message = item, let body = message.body else { return }

        self.contentView.addSubview(self.bubbleView)
        self.contentView.addSubview(self.textView)
        let textColor: Color  = .white

        let attributedString = AttributedString(body,
                                                font: .medium,
                                                size: 18,
                                                color: textColor,
                                                kern: 0)

        self.textView.set(attributed: attributedString,
                          alignment: .left,
                          lineCount: 0,
                          lineBreakMode: .byWordWrapping,
                          stringCasing: .unchanged,
                          isEditable: false,
                          linkColor: textColor)

        self.textView.isEditable = false
        self.textView.isScrollEnabled = false
        self.textView.isSelectable = true

        self.bubbleView.set(backgroundColor: message.backgroundColor)
        self.bubbleView.roundCorners()
    }
}
