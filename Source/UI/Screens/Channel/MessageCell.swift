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
    static var hasXib: Bool = false

    let textView = MessageTextView()

    func configure(with item: MessageType?) {
        guard let type = item else { return }

        self.contentView.addSubview(self.textView)

        self.textView.set(text: type.body)
        self.textView.set(backgroundColor: type.backgroundColor)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if self.textView.numberOfLines == 1 {
            self.textView.layer.cornerRadius = self.textView.halfHeight
        } else {
            self.textView.roundCorners()
        }
    }
}
