//
//  ProfileDetailCell.swift
//  Benji
//
//  Created by Benji Dodgson on 10/15/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ProfileDetailCell: UICollectionViewCell {

    let titleLabel = XSmallLabel()
    let label = SmallSemiBoldLabel()
    let lineView = View()
    let imageView = UIImageView(image: UIImage(systemName: "info.circle"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializeSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initializeSubviews() {
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.label)
        self.contentView.addSubview(self.lineView)
        self.contentView.addSubview(self.imageView)
        self.imageView.isHidden = true
        self.imageView.tintColor = Color.lightPurple.color
        self.lineView.set(backgroundColor: .background3)
    }

    func configure(with detail: ProfileDisplayable) {

        self.titleLabel.set(text: detail.title)
        self.label.set(text: detail.text)
        self.imageView.isHidden = !detail.hasDetail
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.titleLabel.size = CGSize(width: self.contentView.width - Theme.contentOffset, height: 20)
        self.titleLabel.left = 0
        self.titleLabel.top = 0

        self.label.size = self.titleLabel.size
        self.label.left = self.titleLabel.left
        self.label.top = self.titleLabel.bottom + 5

        self.lineView.size = CGSize(width: self.contentView.width, height: 2)
        self.lineView.left = self.titleLabel.left
        self.lineView.top = self.label.bottom + 5

        self.imageView.size = CGSize(width: 26, height: 26)
        self.imageView.centerOnY()
        self.imageView.right = self.contentView.right
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.titleLabel.text = nil
        self.label.text = nil
        self.imageView.isHidden = true
    }
}
