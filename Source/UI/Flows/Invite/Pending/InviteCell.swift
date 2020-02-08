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

    func configure(with item: Inviteable?) {
        guard let inviteable = item else { return }

        self.content.configure(with: inviteable)
    }

    func collectionViewManagerWillDisplay() {}
    func collectionViewManagerDidEndDisplaying() {}

    override func layoutSubviews() {
        super.layoutSubviews()

        self.content.expandToSuperviewSize()
    }
}
