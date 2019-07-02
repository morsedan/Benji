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
    typealias ItemType = MessageType
    static let offset: CGFloat = 10

    let textView = MessageTextView()
    let bubbleView = View()

    func configure(with item: MessageType?) {
        guard let type = item else { return }

        self.contentView.addSubview(self.bubbleView)
        self.contentView.addSubview(self.textView)

        var body: Localized
        switch type {
        case .system(let message):
            body = message.body
        case .message(let message):
            body = String(optional: message.body)
        }

        self.textView.set(text: body)
        self.bubbleView.set(backgroundColor: type.backgroundColor)
        self.bubbleView.roundCorners()
    }
}
