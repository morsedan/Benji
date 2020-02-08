//
//  ProfileDetailCell.swift
//  Benji
//
//  Created by Benji Dodgson on 10/15/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ProfileDetailCell: UICollectionViewCell {

    let titleLabel = SmallLabel()
    let label = SmallBoldLabel()
    let lineView = View()
    let button = Button()

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
        self.contentView.addSubview(self.button)
        self.button.isHidden = true
        self.lineView.set(backgroundColor: .background3)
    }

    func configure(with item: ProfileItem, for user: User) {
        switch item {
        case .picture:
            break
        case .name:
            self.titleLabel.set(text: "Name")
            self.label.set(text: user.fullName)
        case .handle:
            self.titleLabel.set(text: "Handle")
            self.label.set(text: String(optional: user.handle))
        case .localTime:
            self.titleLabel.set(text: "Local Time")
            self.label.set(text: Date.nowInLocalFormat)
        case .routine:
            self.getRoutine()
        case .invites:
            self.getInvites()
        }

        self.button.isHidden = true
        self.contentView.layoutNow()
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

        self.button.size = CGSize(width: 80, height: 30)
        self.button.centerOnY()
        self.button.right = self.contentView.right
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.titleLabel.text = nil
        self.label.text = nil
        self.button.isHidden = true
    }

    private func getRoutine() {
//        self.titleLabel.set(text: detail.title)
//        self.label.set(text: detail.text)
//        if let text = detail.buttonText {
//            self.button.isHidden = false
//            self.button.set(style: .normal(color: .lightPurple, text: text))
//        }

    }

    private func getInvites() {

    }
}
