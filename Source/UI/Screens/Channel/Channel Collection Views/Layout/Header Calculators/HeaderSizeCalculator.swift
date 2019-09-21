//
//  HeaderCellSizeCalculator.swift
//  Benji
//
//  Created by Benji Dodgson on 9/21/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class HeaderSizeCalculator {

    /// The layout object for which the cell size calculator is used.
    unowned let channelLayout: ChannelCollectionViewFlowLayout

    /// Used to configure the layout attributes for a given cell.
    ///
    /// - Parameters:
    /// - attributes: The attributes of the cell.
    /// The default does nothing
    func configure(attributes: UICollectionViewLayoutAttributes) {}

    /// Used to size an item at a given `IndexPath`.
    ///
    /// - Parameters:
    /// - indexPath: The `IndexPath` of the item to be displayed.
    /// The default return .zero
    func sizeForHeader(at section: Int) -> CGSize { return .zero }

    init(layout: ChannelCollectionViewFlowLayout) {
        self.channelLayout = layout
    }
}
