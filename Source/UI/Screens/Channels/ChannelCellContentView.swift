//
//  ChannelCellContentView.swift
//  Benji
//
//  Created by Benji Dodgson on 6/29/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ChannelCellContentView: View {

    private(set) var titleLabel = RegularBoldLabel()
    private(set) var purposeLabel = SmallLabel()
    private(set) var stackedAvatarView = StackedAvatarView()

    override func initializeSubviews() {
        super.initializeSubviews()
        
        self.addSubview(self.stackedAvatarView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.purposeLabel)

        self.roundCorners()
        self.set(backgroundColor: .background2)
    }

    func configure(with type: ChannelType) {

        switch type {
        case .system(let channel):
            self.stackedAvatarView.set(items: channel.avatars)
        case .channel(let channel):
            channel.getMembersAsUsers().observe { (result) in
                switch result {
                case .success(let users):
                    let notMeUsers = users.filter { (user) -> Bool in
                        return user.objectId != User.current()?.objectId
                    }

                    self.stackedAvatarView.set(items: notMeUsers)

                case .failure(let error):
                    print(error)
                }
            }
        }

        self.titleLabel.set(text: type.displayName)
        self.purposeLabel.set(text: type.purpose, color: .background4)
        self.layoutNow()
    }

    func highlight(text: String) {
        guard let attributedText = self.titleLabel.attributedText, attributedText.string.contains(text) else { return }

        let newString = NSMutableAttributedString(attributedString: attributedText)

        if let range = attributedText.string.range(of: text) {
            let nsRange = text.nsRange(from: range)
            newString.addAttributes([NSAttributedString.Key.foregroundColor: Color.lightPurple.color], range: nsRange)
        }

        self.titleLabel.attributedText = newString
        self.layoutNow()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.stackedAvatarView.setSize()
        self.stackedAvatarView.left = Theme.contentOffset
        self.stackedAvatarView.centerOnY()

        self.titleLabel.setSize(withWidth: self.width * 0.7)
        self.titleLabel.left = self.stackedAvatarView.right + 10
        self.titleLabel.top = self.stackedAvatarView.top

        self.purposeLabel.setSize(withWidth: self.width * 0.7)
        self.purposeLabel.left = self.titleLabel.left
        self.purposeLabel.top = self.titleLabel.bottom + 4
    }
}
