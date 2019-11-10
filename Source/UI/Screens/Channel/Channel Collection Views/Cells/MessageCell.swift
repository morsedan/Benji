//
//  ChannelCell.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient

class MessageCell: UICollectionViewCell {

    let avatarView = AvatarView()
    let bubbleView = View()
    let textView = MessageTextView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.initializeViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.initializeViews()
    }

    private func initializeViews() {
        self.contentView.addSubview(self.avatarView)
        self.contentView.addSubview(self.bubbleView)
        self.contentView.addSubview(self.textView)

        let view = UIView(frame: self.bounds)
        view.set(backgroundColor: .background2)
        self.backgroundView = view 
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        guard let attributes = layoutAttributes as? ChannelCollectionViewLayoutAttributes else { return }

        self.layoutContent(with: attributes)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.textView.text = nil
    }

    func configure(with message: Messageable) {

        if !message.isFromCurrentUser {
            self.avatarView.set(avatar: message.avatar)
        }
        self.textView.set(text: message.text)

        let backgroundColor: Color = message.isFromCurrentUser ? .lightPurple : .purple
        self.bubbleView.set(backgroundColor: backgroundColor)
    }

    private func layoutContent(with attributes: ChannelCollectionViewLayoutAttributes) {
        if attributes.isFromCurrentUser {
            self.layoutOutgoing(with: attributes)
        } else {
            self.layoutIncoming(with: attributes)
        }
    }

    // INCOMING
    private func layoutIncoming(with attributes: ChannelCollectionViewLayoutAttributes) {
        self.avatarView.size = attributes.avatarSize
        self.avatarView.left = attributes.avatarLeadingPadding

        self.textView.size = attributes.messageTextViewSize
        self.textView.top = attributes.messageTextViewVerticalPadding
        self.textView.left = attributes.messageTextViewHorizontalPadding

        self.bubbleView.size = attributes.bubbleViewSize
        self.bubbleView.top = 0
        self.bubbleView.left = self.textView.left - attributes.bubbleViewHorizontalPadding
        self.bubbleView.layer.maskedCorners = attributes.maskedCorners
        self.bubbleView.roundCorners()
        self.avatarView.top = self.bubbleView.top
    }

    // OUTGOING
    private func layoutOutgoing(with attributes: ChannelCollectionViewLayoutAttributes) {
        self.avatarView.size = .zero
        self.avatarView.left = attributes.avatarLeadingPadding

        self.textView.size = attributes.messageTextViewSize
        self.textView.top = attributes.messageTextViewVerticalPadding
        self.textView.right = attributes.size.width - attributes.messageTextViewHorizontalPadding

        self.bubbleView.size = attributes.bubbleViewSize
        self.bubbleView.top = 0
        self.bubbleView.right = self.textView.right + attributes.bubbleViewHorizontalPadding
        self.bubbleView.layer.maskedCorners = attributes.maskedCorners
        self.bubbleView.roundCorners()
    }
}
