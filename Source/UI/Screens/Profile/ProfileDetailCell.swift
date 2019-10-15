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
    }

    func configure(with detail: ProfileDisplayable) {

        self.titleLabel.set(text: detail.title)
        self.label.set(text: detail.text)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.titleLabel.size = CGSize(width: self.contentView.width - Theme.contentOffset, height: 20)
        self.titleLabel.left = Theme.contentOffset
        self.titleLabel.top = 0

        self.label.size = self.titleLabel.size
        self.label.left = self.titleLabel.left
        self.label.top = self.titleLabel.bottom + 5

        self.lineView.size = CGSize(width: self.contentView.width - Theme.contentOffset, height: 2)
        self.lineView.left = self.titleLabel.left
        self.lineView.top = self.label.bottom + 5
    }
}
