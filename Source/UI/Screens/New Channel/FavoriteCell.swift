//
//  FavoriteCell.swift
//  Benji
//
//  Created by Benji Dodgson on 8/27/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class FavoriteCell: UICollectionViewCell {
    static let reuseID = "FavoriteCell"

    let avatarView = AvatarView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialize() {
        self.contentView.addSubview(self.avatarView)
    }

    func configure(with avatar: Avatar) {
        self.avatarView.set(avatar: avatar)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.avatarView.frame = self.contentView.bounds
    }
}
