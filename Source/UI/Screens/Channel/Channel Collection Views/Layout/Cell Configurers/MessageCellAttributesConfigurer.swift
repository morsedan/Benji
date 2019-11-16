//
//  MessageCellAttributesConfigurer.swift
//  Benji
//
//  Created by Benji Dodgson on 11/10/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class MessageCellAttributesConfigurer: ChannelCellAttributesConfigurer {

    var avatarSize = CGSize(width: 30, height: 30)
    var avatarLeadingPadding: CGFloat = 8
    var messageTextViewVerticalPadding: CGFloat = 10
    var messageTextViewHorizontalPadding: CGFloat = 20
    var bubbleViewHorizontalPadding: CGFloat = 14
    private let widthRatio: CGFloat = 0.8

    override func configure(with message: Messageable,
                            previousMessage: Messageable?,
                            nextMessage: Messageable?,
                            for layout: ChannelCollectionViewFlowLayout,
                            attributes: ChannelCollectionViewLayoutAttributes) {

        attributes.attributes.isFromCurrentUser = message.isFromCurrentUser

        attributes.attributes.avatarSize = self.avatarSize
        attributes.attributes.avatarLeadingPadding = self.avatarLeadingPadding

        let textViewSize = self.getMessageTextViewSize(with: message, for: layout)
        attributes.attributes.messageTextViewSize = textViewSize
        attributes.attributes.messageTextViewVerticalPadding = self.messageTextViewVerticalPadding
        attributes.attributes.messageTextViewMaxWidth = layout.itemWidth * self.widthRatio

        let leadingPaddingForIncoming = self.avatarSize.width + self.avatarLeadingPadding + self.messageTextViewHorizontalPadding
        let leadingPadding = message.isFromCurrentUser ? self.messageTextViewHorizontalPadding + self.avatarLeadingPadding : leadingPaddingForIncoming
        attributes.attributes.messageTextViewHorizontalPadding = leadingPadding

        let bubbleHeight = textViewSize.height + (self.messageTextViewVerticalPadding * 2)
        let bubbleWidth = textViewSize.width + (self.bubbleViewHorizontalPadding * 2)
        attributes.attributes.bubbleViewSize = CGSize(width: bubbleWidth, height: bubbleHeight)
        attributes.attributes.bubbleViewHorizontalPadding = self.bubbleViewHorizontalPadding

        //Determine masked corners
        if message.isFromCurrentUser {
            if let previous = previousMessage, previous.authorID == message.authorID {
                attributes.attributes.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
            } else {
                attributes.attributes.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
            }
        } else {
            if let next = nextMessage, next.authorID == message.authorID {
                attributes.attributes.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            } else {
                attributes.attributes.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner]
            }
        }
    }

    override func size(with message: Messageable?, for layout: ChannelCollectionViewFlowLayout) -> CGSize {
        guard let msg = message else { return .zero }

        let itemHeight = self.cellContentHeight(with: msg, for: layout)
        return CGSize(width: layout.itemWidth, height: itemHeight)
    }

    private func cellContentHeight(with message: Messageable,
                                   for layout: ChannelCollectionViewFlowLayout) -> CGFloat {

        return self.getMessageTextViewSize(with: message, for: layout).height
            + (self.messageTextViewVerticalPadding * 2)
    }

    private func getMessageTextViewSize(with message: Messageable,
                                        for layout: ChannelCollectionViewFlowLayout) -> CGSize {

        let attributed = AttributedString(message.text,
                                          fontType: .smallSemiBold,
                                          color: .white)

        let attributedString = attributed.string
        let maxWidth = (layout.itemWidth * self.widthRatio) - self.avatarLeadingPadding - self.avatarSize.width
        let size = attributedString.getSize(withWidth: maxWidth)
        return size
    }
}
