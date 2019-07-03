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

    func configure(with item: MessageType?) {
        guard let type = item else { return }

        self.contentView.addSubview(self.textView)

        self.textView.set(text: type.body)
        self.textView.set(backgroundColor: type.backgroundColor)
        self.textView.roundCorners()
    }
}
