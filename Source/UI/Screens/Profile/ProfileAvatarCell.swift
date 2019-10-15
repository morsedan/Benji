//
//  ProfileHeaderCell.swift
//  Benji
//
//  Created by Benji Dodgson on 10/15/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ProfileAvatarCell: UICollectionViewCell {

    private let avatarView = AvatarView()
    private let displayLabel = RegularSemiBoldLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializeSubViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initializeSubViews() {
        self.contentView.addSubview(self.avatarView)
        self.contentView.addSubview(self.displayLabel)
    }

    func configure(with detail: ProfileDisplayable) {
        guard let avatar = detail.avatar else { return }

        self.avatarView.setBorder(color: .clear)
        self.avatarView.showLargeImage = true
        self.avatarView.set(avatar: avatar)
        self.displayLabel.set(text: avatar.fullName, stringCasing: .capitalized)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let avatarHeight = self.contentView.height
        self.avatarView.size = CGSize(width: avatarHeight, height: avatarHeight)
        self.avatarView.top = 0
        self.avatarView.centerOnX()

        self.displayLabel.setSize(withWidth: self.contentView.width * 0.8)
        self.displayLabel.bottom = self.avatarView.bottom - 10
        self.displayLabel.left = Theme.contentOffset
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.avatarView.imageView.image = nil
        self.displayLabel.text = nil
    }
}
