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

    func update(isSelected: Bool) {
        self.avatarView.alpha = isSelected ? 1 : 0.5
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.avatarView.frame = self.contentView.bounds
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.avatarView.displayable = UIImage()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
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
