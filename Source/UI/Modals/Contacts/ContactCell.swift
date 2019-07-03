//
//  ContactCell.swift
//  Benji
//
//  Created by Benji Dodgson on 6/30/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Contacts

class ContactCell: UICollectionViewCell, DisplayableCell {
    typealias ItemType = CNContact
    let avatarView = AvatarView()
    let nameLabel = NameLabel()

    func configure(with item: CNContact?) {
        guard let contact = item else { return }

        self.contentView.addSubview(self.avatarView)
        self.contentView.addSubview(self.nameLabel)

        self.nameLabel.set(text: contact.fullName)
        self.avatarView.set(avatar: contact)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.avatarView.size = CGSize(width: 64, height: 64)
        self.avatarView.left = Theme.contentOffset
        self.avatarView.centerOnY()

        let nameWidth = self.contentView.width - self.avatarView.right - (Theme.contentOffset * 2)
        self.nameLabel.size = CGSize(width: nameWidth, height: 40)
        self.nameLabel.centerY = self.avatarView.centerY
        self.nameLabel.left = self.avatarView.right + Theme.contentOffset
    }
}
