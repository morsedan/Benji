//
//  ContactCell.swift
//  Benji
//
//  Created by Benji Dodgson on 6/30/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Contacts

class ContactCell: UICollectionViewCell, ManageableCell {
    typealias ItemType = CNContact

    var onLongPress: (() -> Void)?

    let avatarView = AvatarView()
    let nameLabel = RegularLabel()
    let button = Button()

    func configure(with item: CNContact?) {
        guard let contact = item else { return }

        self.contentView.addSubview(self.avatarView)
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.button)

        self.nameLabel.set(text: contact.fullName)
        self.avatarView.set(avatar: contact)
    }

    func update(isSelected: Bool) {
        if isSelected {
            self.button.set(style: .normal(color: .teal, text: "Added"))
        } else {
            self.button.set(style: .normal(color: .blue, text: "Add"))
        }
    }

    func collectionViewManagerWillDisplay() {}
    func collectionViewManagerDidEndDisplaying() {}

    override func layoutSubviews() {
        super.layoutSubviews()

        self.avatarView.size = CGSize(width: 44, height: 60)
        self.avatarView.left = Theme.contentOffset
        self.avatarView.centerOnY()

        let nameWidth = self.contentView.width - self.avatarView.right - (Theme.contentOffset * 2)
        self.nameLabel.size = CGSize(width: nameWidth, height: 40)
        self.nameLabel.centerY = self.avatarView.centerY
        self.nameLabel.left = self.avatarView.right + Theme.contentOffset

        self.button.size = CGSize(width: 80, height: 30)
        self.button.centerOnY()
        self.button.right = self.contentView.right
    }
}
