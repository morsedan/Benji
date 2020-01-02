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
    var itemSize: CGSize = CGSize(width: 30, height: 38)
    var offsetMultiplier: CGFloat = 0.5

    func set(items: [Avatar]) {
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

    func setSize() {
        guard self.imageViews.count > 1 else {
            return self.size = self.itemSize
        }

        var totalWidth: CGFloat = 0
        for (index, _ ) in self.imageViews.enumerated() {
            let offset = CGFloat(index) * self.itemSize.width * self.offsetMultiplier
            totalWidth += offset
        }

        totalWidth += self.itemSize.width
        self.size = CGSize(width: totalWidth, height: self.itemSize.height)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        for (index, imageView) in self.imageViews.enumerated() {

            let offset = CGFloat(index) * self.itemSize.width * self.offsetMultiplier
            imageView.size = self.itemSize
            imageView.right = self.width - offset
            imageView.centerOnY()
        }
    }
}

