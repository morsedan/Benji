//
//  EmptyChannelView.swift
//  Benji
//
//  Created by Benji Dodgson on 7/6/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class EmptyChannelView: View {

    let titleLabel = Label()
    let descriptionLabel = Label()
    let actionLabel = Label()
    let stackedAvatarView = StackedAvatarView()

    var titleText: Localized? {
        didSet {
            guard let text = self.titleText else { return }

            let attributed = AttributedString(text,
                                              fontType: .display1,
                                              color: .white)
            self.titleLabel.set(attributed: attributed,
                                alignment: .center)
        }
    }

    var descriptionText: Localized? {
        didSet {
            guard let text = self.descriptionText else { return }

            let attributed = AttributedString(text,
                                              fontType: .small,
                                              color: .white)
            self.descriptionLabel.set(attributed: attributed,
                                      alignment: .center)
        }
    }

    var actionText: Localized? {
        didSet {
            guard let text = self.actionText else { return }

            let attributed = AttributedString(text,
                                              fontType: .regular,
                                              color: .white)
            self.actionLabel.set(attributed: attributed,
                                 alignment: .center)
        }
    }

    override func initializeSubviews() {
        super.initializeSubviews()
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.descriptionLabel)
        self.addSubview(self.actionLabel)
        self.addSubview(self.stackedAvatarView)

        self.titleText = LocalizedString(id: "", default: "Great!")
        self.descriptionText = LocalizedString(id: "", default: "You and Username are now in a conversation greeting.")
        self.actionText = LocalizedString(id: "", default: "Tap the bottom to compose your first message.")

        let avatar1 = Lorem.avatar()
        let avatar2 = Lorem.avatar()
        self.stackedAvatarView.itemSize = 72
        self.stackedAvatarView.offsetMultiplier = 0.8
        self.stackedAvatarView.set(items: [avatar1, avatar2])
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.titleLabel.setSize(withWidth: self.proportionalWidth)
        self.titleLabel.top = self.height * 0.2
        self.titleLabel.centerOnX()

        self.descriptionLabel.setSize(withWidth: self.proportionalWidth)
        self.descriptionLabel.top = self.titleLabel.bottom + 10
        self.descriptionLabel.centerOnX()

        self.stackedAvatarView.setSize()
        self.stackedAvatarView.top = self.descriptionLabel.bottom + 25
        self.stackedAvatarView.centerOnX()

        self.actionLabel.setSize(withWidth: self.proportionalWidth)
        self.actionLabel.top = self.stackedAvatarView.bottom + 25
        self.actionLabel.centerOnX()
    }
}
