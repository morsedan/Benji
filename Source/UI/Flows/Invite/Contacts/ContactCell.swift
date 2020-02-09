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

    let content = InviteableContentView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializeSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initializeSubviews() {
        self.contentView.addSubview(self.content)
    }

    func configure(with item: CNContact?) {
        guard let contact = item else { return }

        self.content.configure(with: .contact(contact))
    }

    func update(isSelected: Bool) {
        if isSelected {
            self.content.button.set(style: .normal(color: .lightPurple, text: "Added"))
        } else {
            self.content.button.set(style: .normal(color: .blue, text: "Invite"))
        }
    }

    func collectionViewManagerWillDisplay() {}
    func collectionViewManagerDidEndDisplaying() {}

    override func layoutSubviews() {
        super.layoutSubviews()

        self.content.expandToSuperviewSize()
    }
}
