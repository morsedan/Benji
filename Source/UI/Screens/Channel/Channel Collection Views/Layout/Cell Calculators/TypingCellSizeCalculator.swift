//
//  TypingCellSizeCalculator.swift
//  Benji
//
//  Created by Benji Dodgson on 9/15/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class TypingCellSizeCalculator: CellSizeCalculator {

    var height: CGFloat = 62

    override func sizeForItem(at indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = self.channelLayout.collectionView?.bounds.width ?? 0
        let contentInset = self.channelLayout.collectionView?.contentInset ?? .zero
        let inset = self.channelLayout.sectionInset.horizontal + contentInset.horizontal
        return CGSize(width: collectionViewWidth - inset, height: self.height)
    }
}
