//
//  ChannelCollectionViewManager.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient

class ChannelCollectionViewManager: CollectionViewManager<TCHMessage, ChannelCell> {

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: ChannelCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ChannelCell.reuseID,
            for: indexPath) as! ChannelCell

        if let message = self.items.value[safe: indexPath.row] {
            cell.configure(with: message, indexPath: indexPath)

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

        cell.didSelect = { [weak self] indexPath in
            guard let `self` = self, let item = self.items.value[safe: indexPath.row] else { return }
            self.delegate?.collectionViewManager(didSelect: item, at: indexPath)
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

        let attributedString = AttributedString(body,
                                                font: .medium,
                                                size: 18,
                                                color: .white,
                                                kern: 0)

        let maxWidth = (collectionView.width - 20) * 0.8
        return attributedString.string.getSize(withWidth: maxWidth)
    }
}
