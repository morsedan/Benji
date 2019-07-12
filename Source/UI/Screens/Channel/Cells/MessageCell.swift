//
//  ChannelCell.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient
import PureLayout

class MessageCell: UICollectionViewCell {
    
    static let offset: CGFloat = 10

    let receiverContent: ReceiverMessageCellContentView = UINib.loadView()
    let senderContent: SenderMessageCellContentView = UINib.loadView()

    func configure(with item: MessageType?) {
        guard let type = item else { return }

        if type.isFromCurrentUser {
            self.setupSenderContent(with: type)
        } else {
            self.setupReceiverContent(with: type)
        }
    }

    private func setupReceiverContent(with type: MessageType) {
        self.contentView.addSubview(self.receiverContent)
        self.receiverContent.autoPinEdgesToSuperviewEdges()

        self.receiverContent.set(type: type)
    }

    private func setupSenderContent(with type: MessageType) {
        self.contentView.addSubview(self.senderContent)
        self.senderContent.autoPinEdgesToSuperviewEdges()

        self.senderContent.textView.set(text: type.body)
        self.senderContent.bubbleView.set(backgroundColor: type.backgroundColor)
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        self.layoutNow()

        let size = self.contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var frame = layoutAttributes.frame
        frame.size.height = ceil(size.height)
        layoutAttributes.frame = frame
        return layoutAttributes
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.contentView.removeAllSubviews()
    }
}
