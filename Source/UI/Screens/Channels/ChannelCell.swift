//
//  ChannelCell.swift
//  Benji
//
//  Created by Benji Dodgson on 2/3/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ChannelCell: UICollectionViewCell, DisplayableCell {
    var item: DisplayableCellItem?

    var didSelect: ((IndexPath) -> Void)?

    func cellIsReadyForLayout() {

    }
}
