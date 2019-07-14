//
//  MessageSizeCaluculator.swift
//  Benji
//
//  Created by Benji Dodgson on 7/11/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class MessageSizeCalculator: CellSizeCalculator {

    var avatarSize = CGSize(width: 44, height: 44)
    var avatarLeadingPadding: CGFloat = 14
    var messageTextViewVerticalPadding: CGFloat = 10
    var messageTextViewHorizontalPadding: CGFloat = 24
    var bubbleViewHorizontalPadding: CGFloat = 14

    init(layout: ChannelCollectionViewFlowLayout? = nil) {
        super.init()

        self.channelLayout = layout
    }

    override func configure(attributes: UICollectionViewLayoutAttributes) {
        guard let attributes = attributes as? ChannelCollectionViewLayoutAttributes,
        let layout = self.channelLayout else { return }

        let dataSource = layout.dataSource
        let indexPath = attributes.indexPath
        guard let message = dataSource.item(at: indexPath, in: layout.channelCollectionView) else { return }

        attributes.isFromCurrentUser = message.isFromCurrentUser

        attributes.avatarSize = self.avatarSize
        attributes.avatarLeadingPadding = self.avatarLeadingPadding

        let textViewSize = self.getMessageTextViewSize(for: message)
        attributes.messageTextViewSize = textViewSize
        attributes.messageTextViewVerticalPadding = self.messageTextViewVerticalPadding
        attributes.messageTextViewMaxWidth = layout.itemWidth * 0.6
        attributes.messageTextViewHorizontalPadding = self.messageTextViewHorizontalPadding

        let bubbleHeight = textViewSize.height + (self.messageTextViewVerticalPadding * 2)
        let bubbleWidth = textViewSize.width + (self.messageTextViewVerticalPadding * 2)
        attributes.bubbleViewSize = CGSize(width: bubbleWidth, height: bubbleHeight)
        attributes.bubbleViewHorizontalPadding = self.bubbleViewHorizontalPadding
    }

    override func sizeForItem(at indexPath: IndexPath) -> CGSize {
        guard let layout = self.channelLayout,
            let message = layout.dataSource.item(at: indexPath, in: layout.channelCollectionView) else { return .zero }
        
        let itemHeight = self.cellContentHeight(for: message, at: indexPath)
        return CGSize(width: layout.itemWidth, height: itemHeight)
    }

    private func cellContentHeight(for message: MessageType, at indexPath: IndexPath) -> CGFloat {
        return .zero
    }

    private func getMessageTextViewSize(for message: MessageType) -> CGSize {
        guard let layout = self.channelLayout else { return .zero }

        let attributed = AttributedString(message.body,
                                          fontType: .regular,
                                          color: .white)

        let attributedString = attributed.string
        for emojiRange in attributedString.string.getEmojiRanges() {
            attributedString.removeAttributes(atRange: emojiRange)
            if let emojiFont = UIFont(name: "AppleColorEmoji", size: attributed.style.fontType.size) {
                attributedString.addAttributes([NSAttributedString.Key.font: emojiFont], range: emojiRange)
            }
        }

        let maxWidth = (layout.itemWidth * 0.6) - self.avatarLeadingPadding - self.avatarSize.width 
        var size = attributedString.getSize(withWidth: maxWidth)
        size.height += self.messageTextViewVerticalPadding * 2
        return size
    }
}
