//
//  ChannelCollectionViewManager.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ChannelCollectionViewManager: CollectionViewManager<Message, ChannelCell> {

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: ChannelCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ChannelCell.reuseID,
            for: indexPath) as! ChannelCell

        if let item = self.items.value[safe: indexPath.row] {
            cell.configure(with: item,
                           indexPath: indexPath)

            let estimatedSize = self.getSize(for: item, collectionView: collectionView)

            var textViewXOffset: CGFloat = 20
            var bubbleXOffset: CGFloat = 10
            if item.isSender {
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

    private func getSize(for item: Message, collectionView: UICollectionView) -> CGSize {
        let textView = TextView()
        let attributedString = AttributedString(item.text,
                                                font: .regular,
                                                size: 18,
                                                color: .white,
                                                kern: 0)

        let alignment: NSTextAlignment = item.backgroundColor == .darkGray ? .left : .right

        textView.set(attributed: attributedString,
                     alignment: alignment,
                     lineCount: 0,
                     lineBreakMode: .byWordWrapping,
                     stringCasing: .unchanged,
                     isEditable: false,
                     linkColor: .white)

        let maxWidth = (collectionView.width - 20) * 0.8
        return textView.getSize(withWidth: maxWidth)
    }
}
