//
//  ChannelCollectionViewManager.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient

class ChannelCollectionViewManager: CollectionViewManager<MessageCell> {

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MessageCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MessageCell.reuseID,
            for: indexPath) as! MessageCell

        if let message = self.items.value[safe: indexPath.row] {
            cell.configure(with: message)

            let estimatedSize = self.getSize(for: message, collectionView: collectionView)

            var textViewXOffset: CGFloat = 20
            var bubbleXOffset: CGFloat = 10
            if message.isFromCurrentUser {
                textViewXOffset = collectionView.width - estimatedSize.width - 20
                bubbleXOffset = collectionView.width - estimatedSize.width - 30
            }
            cell.textView.frame = CGRect(x: textViewXOffset, y: 5, width: estimatedSize.width, height: estimatedSize.height)
            cell.bubbleView.frame = CGRect(x: bubbleXOffset, y: 0, width: estimatedSize.width + 20, height: estimatedSize.height + 10)
        }

        cell.contentView.onTap { [weak self] (tap) in
            guard let `self` = self, let item = self.items.value[safe: indexPath.row] else { return }
            self.didSelect(item, indexPath)
        }

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let item = self.items.value[safe: indexPath.row] else { return .zero }

        let estimatedSize = self.getSize(for: item, collectionView: collectionView)
        let size = CGSize(width: collectionView.width, height: estimatedSize.height + 10)
        return size 
    }

    private func getSize(for item: TCHMessage, collectionView: UICollectionView) -> CGSize {
        guard let body = item.body else { return .zero }

        let attributed = AttributedString(body,
                                          fontType: .medium,
                                          color: .white,
                                          kern: 0)

        let attributedString = attributed.string
        for emojiRange in attributedString.string.getEmojiRanges() {
            attributedString.removeAttributes(atRange: emojiRange)
            if let emojiFont = UIFont(name: "AppleColorEmoji", size: attributed.style.fontType.size) {
                attributedString.addAttributes([NSAttributedString.Key.font: emojiFont], range: emojiRange)
            }
        }

        let maxWidth = (collectionView.width - 20) * 0.8
        return attributedString.getSize(withWidth: maxWidth)
    }
}
