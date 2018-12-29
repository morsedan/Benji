//
//  ChannelCollectionViewManager.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ChannelCollectionViewManager: CollectionViewManager<Message, ChannelCell> {

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let item = self.items.value[safe: indexPath.row] else { return .zero }

        let textView = TextView()
        let attributedString = AttributedString(item.text,
                                                font: .regular,
                                                size: 20,
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

        let textViewSize = textView.getSize(withWidth: collectionView.width * 0.9)
        let size = CGSize(width: collectionView.width, height: textViewSize.height + (ChannelCell.offset * 2))
        return size 
    }

}
