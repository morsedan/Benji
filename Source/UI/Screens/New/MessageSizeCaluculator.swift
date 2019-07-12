//
//  MessageSizeCaluculator.swift
//  Benji
//
//  Created by Benji Dodgson on 7/11/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class MessageSizeCaluculator: CellSizeCalculator {

    var avatarSize = CGSize(width: 44, height: 44)
    var avatarLeadingPadding: CGFloat = 14
    var messageTextViewVerticalPadding: CGFloat = 10

    init(layout: ChannelCollectionViewFlowLayout? = nil) {
        super.init()

        self.channelLayout = layout
    }

    override func configure(attributes: UICollectionViewLayoutAttributes) {
        guard let attributes = attributes as? ChannelCollectionViewLayoutAttributes,
        let layout = self.channelLayout else { return }

        let dataSource = layout.dataSource
        let indexPath = attributes.indexPath
        let message = dataSource.messageForItem(at: indexPath, in: layout.channelCollectionView)

        attributes.avatarSize = self.avatarSize
        attributes.avatarLeadingPadding = self.avatarLeadingPadding
        attributes.messageTextViewSize = self.getMessageTextViewSize(for: message)
        attributes.messageTextViewVerticalPadding = self.messageTextViewVerticalPadding
        attributes.messageTextViewMaxWidth = layout.itemWidth * 0.6
    }

    override func sizeForItem(at indexPath: IndexPath) -> CGSize {
        guard let layout = self.channelLayout else { return .zero }
        let dataSource = layout.dataSource
        let message = dataSource.messageForItem(at: indexPath, in: layout.channelCollectionView)
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
