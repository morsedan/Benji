//
//  OrbCell.swift
//  Benji
//
//  Created by Benji Dodgson on 12/28/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TMROLocalization

class OrbCell: CollectionViewManagerCell, ManageableCell {

    typealias ItemType = OrbCellItem

    let label = RegularSemiBoldLabel()
    let imageView = AvatarView()
    let selectionFeedback = UIImpactFeedbackGenerator()

    override func initializeSubviews() {
        super.initializeSubviews()

        self.contentView.layer.cornerRadius = Theme.cornerRadius
        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.label)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.imageView.size = CGSize(width: 90, height: 90)
        self.imageView.top = 0
        self.imageView.centerOnX()

        self.label.setSize(withWidth: 140)
        self.label.bottom = self.contentView.height - 10
        self.label.centerOnX()
    }

    func configure(with item: OrbCellItem?) {
        guard let orbItem = item else { return }

        self.imageView.set(avatar: orbItem.avatar.value)

        let displayName: Localized = orbItem.avatar.value.handle ?? orbItem.avatar.value.fullName
        self.label.set(text: displayName,
                       color: .white,
                       alignment: .center,
                       stringCasing: .lowercase)
        self.setNeedsLayout()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.label.text = String()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.selectionFeedback.impactOccurred()
        self.scaleDown()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.scaleUp()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.scaleUp()
    }
}
