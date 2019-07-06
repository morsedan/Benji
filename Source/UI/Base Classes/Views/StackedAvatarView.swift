//
//  StackedAvatarView.swift
//  Benji
//
//  Created by Benji Dodgson on 7/6/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class StackedAvatarView: View {

    private var imageViews: [AvatarView] = []
    private let maxItems: Int = 3
    var itemSize: CGFloat = 30
    var offsetMultiplier: CGFloat = 0.5

    func configure(items: [Avatar]) {
        self.set(backgroundColor: .red)
        self.imageViews.removeAllFromSuperview(andRemoveAll: true)

        let max: Int = min(items.count, self.maxItems)
        for index in stride(from: max - 1, through: 0, by: -1) {
            let item: Avatar = items[index]
            let avatarView = AvatarView()
            avatarView.set(avatar: item)
            avatarView.imageView.layer.borderColor = Color.white.color.cgColor
            avatarView.imageView.layer.borderWidth = 2

            self.imageViews.append(avatarView, toSuperview: self)
        }

        self.setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        for (index, imageView) in self.imageViews.enumerated() {

            let offset = CGFloat(index) * self.itemSize * offsetMultiplier
            imageView.size = CGSize(width: self.itemSize, height: self.itemSize)
            imageView.left = self.width - offset
            imageView.centerOnY()
        }
    }
}

