//
//  HomeTabView.swift
//  Benji
//
//  Created by Benji Dodgson on 12/17/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class HomeTabView: View {

    private(set) var profileItem = ImageViewButton()
    private(set) var feedItem = ImageViewButton()
    private(set) var channelsItem = ImageViewButton()
    private(set) var settingsItem = ImageViewButton()
    private(set) var newChannelButton = HomeNewChannellButton()

    private let flashLightView = FlashLightView(with: .teal)

    private let selectionFeedback = UIImpactFeedbackGenerator(style: .light)

    var currentContent: HomeContent?
    
    override func initializeSubviews() {
        super.initializeSubviews()

        self.set(backgroundColor: .clear)

        self.addSubview(self.flashLightView)
        self.addSubview(self.profileItem)
        self.addSubview(self.feedItem)
        self.addSubview(self.channelsItem)
        self.addSubview(self.newChannelButton)
        self.addSubview(self.settingsItem)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.newChannelButton.size = CGSize(width: 60, height: 60)
        self.newChannelButton.top = 0
        self.newChannelButton.centerOnX()

        let itemWidth = (self.width - (self.newChannelButton.width + 40)) * 0.25
        let itemSize = CGSize(width: itemWidth, height: self.newChannelButton.height)
        self.profileItem.size = itemSize
        self.profileItem.top = 0
        self.profileItem.left = 0

        self.feedItem.size = itemSize
        self.feedItem.top = 0
        self.feedItem.left = self.profileItem.right

        self.channelsItem.size = itemSize
        self.channelsItem.top = 0
        self.channelsItem.left = self.newChannelButton.right + 20

        self.settingsItem.size = itemSize
        self.settingsItem.top = 0
        self.settingsItem.left = self.channelsItem.right

        self.flashLightView.size = CGSize(width: itemWidth * 0.55, height: 2)
        self.flashLightView.top = itemSize.height

        guard let current = self.currentContent else { return }
        let centerX: CGFloat

        switch current {
        case .feed(_):
            centerX = self.feedItem.centerX
        case .channels(_):
            centerX = self.channelsItem.centerX
        case .profile(_):
            centerX = self.profileItem.centerX
        }

        self.flashLightView.centerX = centerX
    }

    func updateTabItems(for contentType: HomeContent) {
        self.selectionFeedback.impactOccurred()

        print(contentType)
        self.currentContent = contentType

        switch contentType {
        case .feed:
            self.feedItem.imageView.image = UIImage(systemName: "square.stack.fill")
            self.profileItem.imageView.image = UIImage(systemName: "person.crop.circle")
            self.channelsItem.imageView.image = UIImage(systemName: "bubble.left.and.bubble.right")
            self.settingsItem.imageView.image = UIImage(systemName: "info.circle")
        case .channels:
            self.feedItem.imageView.image = UIImage(systemName: "square.stack")
            self.profileItem.imageView.image = UIImage(systemName: "person.crop.circle")
            self.channelsItem.imageView.image = UIImage(systemName: "bubble.left.and.bubble.right.fill")
            self.settingsItem.imageView.image = UIImage(systemName: "info.circle")
        case .profile:
            self.feedItem.imageView.image = UIImage(systemName: "square.stack")
            self.profileItem.imageView.image = UIImage(systemName: "person.crop.circle.fill")
            self.channelsItem.imageView.image = UIImage(systemName: "bubble.left.and.bubble.right")
            self.settingsItem.imageView.image = UIImage(systemName: "info.circle")
        }

        self.flashLightView.animateOut { [unowned self] in
            self.layoutNow()
            self.flashLightView.animateIn()
        }
    }
}
