//
//  FavoriteCell.swift
//  Benji
//
//  Created by Benji Dodgson on 8/27/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse

class FavoriteCell: UICollectionViewCell, DisplayableCell {
    typealias ItemType = PFUser

    let avatarView = AvatarView()

    func configure(with item: PFUser?) {
        guard let avatar = item else { return }

        self.contentView.addSubview(self.avatarView)
        self.avatarView.set(avatar: avatar)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.avatarView.frame = self.contentView.bounds
    }
}
