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
    private(set) var stackedAvatarView = StackedAvatarView()

    override func initializeSubviews() {
        super.initializeSubviews()
        
        self.addSubview(self.stackedAvatarView)
        self.addSubview(self.titleLabel)
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
                    self.stackedAvatarView.set(items: users)
                case .failure(let error):
                    print(error)
                }
            }
        }

        self.titleLabel.set(text: type.displayName)
        self.layoutNow()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.stackedAvatarView.height = 40
        self.stackedAvatarView.right = self.width - 16
        self.stackedAvatarView.centerOnY()

        self.titleLabel.setSize(withWidth: 200)
        self.titleLabel.left = Theme.contentOffset
        self.titleLabel.centerOnY()
    }
}
