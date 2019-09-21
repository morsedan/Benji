//
//  MessageSizeCaluculator.swift
//  Benji
//
//  Created by Benji Dodgson on 7/11/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class MessageSizeCalculator: CellSizeCalculator {

    var avatarSize = CGSize(width: 30, height: 30)
    var avatarLeadingPadding: CGFloat = 8
    var messageTextViewVerticalPadding: CGFloat = 10
    var messageTextViewHorizontalPadding: CGFloat = 20
    var bubbleViewHorizontalPadding: CGFloat = 14
    private let widthRatio: CGFloat = 0.8

    override func configure(attributes: UICollectionViewLayoutAttributes) {
        guard let attributes = attributes as? ChannelCollectionViewLayoutAttributes else { return }

        let dataSource = self.channelLayout.dataSource
        let indexPath = attributes.indexPath
        guard let message = dataSource.item(at: indexPath) else { return }

        attributes.isFromCurrentUser = message.isFromCurrentUser

        attributes.avatarSize = self.avatarSize
        attributes.avatarLeadingPadding = self.avatarLeadingPadding

        let textViewSize = self.getMessageTextViewSize(for: message)
        attributes.messageTextViewSize = textViewSize
        attributes.messageTextViewVerticalPadding = self.messageTextViewVerticalPadding
        attributes.messageTextViewMaxWidth = self.channelLayout.itemWidth * self.widthRatio

        let leadingPaddingForIncoming = self.avatarSize.width + self.avatarLeadingPadding + self.messageTextViewHorizontalPadding
        let leadingPadding = message.isFromCurrentUser ? self.messageTextViewHorizontalPadding + self.avatarLeadingPadding : leadingPaddingForIncoming
        attributes.messageTextViewHorizontalPadding = leadingPadding

        let bubbleHeight = textViewSize.height + (self.messageTextViewVerticalPadding * 2)
        let bubbleWidth = textViewSize.width + (self.bubbleViewHorizontalPadding * 2)
        attributes.bubbleViewSize = CGSize(width: bubbleWidth, height: bubbleHeight)
        attributes.bubbleViewHorizontalPadding = self.bubbleViewHorizontalPadding

        //Determine masked corners
        if message.isFromCurrentUser {
            let previousIndexPath = IndexPath(item: indexPath.item - 1, section: indexPath.section)
            if let previousMessage = dataSource.item(at: previousIndexPath), previousMessage.author == message.author {
                attributes.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
            } else {
                attributes.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
            }
        } else {
            let nextIndexPath = IndexPath(item: indexPath.item + 1, section: indexPath.section)
            if let nextMessage = dataSource.item(at: nextIndexPath), nextMessage.author == message.author {
                attributes.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            } else {
                attributes.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner]
            }
        }
    }

    override func sizeForItem(at indexPath: IndexPath) -> CGSize {
        guard let message = self.channelLayout.dataSource.item(at: indexPath) else { return .zero }
        
        let itemHeight = self.cellContentHeight(for: message)
        return CGSize(width: self.channelLayout.itemWidth, height: itemHeight)
    }

    private func cellContentHeight(for message: MessageType) -> CGFloat {
        return self.getMessageTextViewSize(for: message).height + (self.messageTextViewVerticalPadding * 2)
    }

    private func getMessageTextViewSize(for message: MessageType) -> CGSize {

        let attributed = AttributedString(message.body,
                                          fontType: .regular,
                                          color: .white)

        let attributedString = attributed.string
        let maxWidth = (self.channelLayout.itemWidth * self.widthRatio) - self.avatarLeadingPadding - self.avatarSize.width
        let size = attributedString.getSize(withWidth: maxWidth)
        return size
    }
}
