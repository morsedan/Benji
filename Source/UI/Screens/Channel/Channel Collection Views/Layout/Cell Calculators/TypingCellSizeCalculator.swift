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

    init(layout: ChannelCollectionViewFlowLayout? = nil) {
        super.init()
        self.channelLayout = layout
    }

    override func sizeForItem(at indexPath: IndexPath) -> CGSize {
        guard let layout = self.channelLayout else { return .zero }
        let collectionViewWidth = layout.collectionView?.bounds.width ?? 0
        let contentInset = layout.collectionView?.contentInset ?? .zero
        let inset = layout.sectionInset.horizontal + contentInset.horizontal
        return CGSize(width: collectionViewWidth - inset, height: self.height)
    }
}
