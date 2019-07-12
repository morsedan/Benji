//
//  CellSizeCalculator.swift
//  Benji
//
//  Created by Benji Dodgson on 7/11/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

/// An object is responsible for
/// sizing and configuring cells for given `IndexPath`s.
class CellSizeCalculator {

    /// The layout object for which the cell size calculator is used.
    weak var channelLayout: ChannelCollectionViewFlowLayout?

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
    func sizeForItem(at indexPath: IndexPath) -> CGSize { return .zero }

    init() {}
}
