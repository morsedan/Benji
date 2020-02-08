//
//  InviteCell.swift
//  Benji
//
//  Created by Benji Dodgson on 2/8/20.
//  Copyright © 2020 Benjamin Dodgson. All rights reserved.
//

import Foundation

class InviteCell: UICollectionViewCell, ManageableCell {
    typealias ItemType = Inviteable

    var onLongPress: (() -> Void)?

    func configure(with item: Inviteable?) {
        guard let inviteable = item else { return }
    }

    func collectionViewManagerWillDisplay() {

    }

    func collectionViewManagerDidEndDisplaying() {

    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
