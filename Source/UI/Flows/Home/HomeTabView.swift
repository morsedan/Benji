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
    private(set) var newChannelButton = HomeNewChannellButton()

    private let flashLightView = View()

    private let selectionFeedback = UIImpactFeedbackGenerator(style: .light)
    private var indicatorCenterX: CGFloat?

    var currentContent: HomeContent?
    
    override func initializeSubviews() {
        super.initializeSubviews()

        self.set(backgroundColor: .clear)

        self.addSubview(self.flashLightView)
        self.flashLightView.set(backgroundColor: .purple)
        self.addSubview(self.profileItem)
        self.addSubview(self.feedItem)
        self.addSubview(self.channelsItem)
        self.addSubview(self.newChannelButton)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

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
        self.channelsItem.left = self.feedItem.right

        self.newChannelButton.size = CGSize(width: 60, height: 60)
        self.newChannelButton.top = 0
        self.newChannelButton.right = self.width - Theme.contentOffset

        self.flashLightView.size = CGSize(width: itemWidth * 0.55, height: 2)
        self.flashLightView.bottom = itemSize.height

        guard self.indicatorCenterX == nil else { return }

        self.flashLightView.centerX = self.feedItem.centerX
    }

    func updateTabItems(for contentType: HomeContent) {
        self.selectionFeedback.impactOccurred()

        self.currentContent = contentType

        self.animateIndicator(for: contentType)
    }

    private func animateIndicator(for contentType: HomeContent) {
        let newCenterX: CGFloat

        switch contentType {
        case .feed(_):
            newCenterX = self.feedItem.centerX
        case .channels(_):
            newCenterX = self.channelsItem.centerX
        case .profile(_):
            newCenterX = self.profileItem.centerX
        }

        UIView.animateKeyframes(withDuration: 0.5, delay: 0.0, options: [.calculationModeLinear], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.33) {
                self.flashLightView.transform = CGAffineTransform(scaleX: 0.2, y: 1.0)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.33, relativeDuration: 0.33) {
                self.flashLightView.centerX = newCenterX
                self.setNeedsLayout()
            }
            UIView.addKeyframe(withRelativeStartTime: 0.66, relativeDuration: 0.33) {
                self.flashLightView.transform = .identity
            }
        }) { _ in
            self.indicatorCenterX = newCenterX
            self.updateButtons(for: contentType)
        }
    }

    private func updateButtons(for contentType: HomeContent) {
        switch contentType {
        case .feed:
            self.feedItem.imageView.image = UIImage(systemName: "square.stack.fill")
            self.profileItem.imageView.image = UIImage(systemName: "person.crop.circle")
            self.channelsItem.imageView.image = UIImage(systemName: "bubble.left.and.bubble.right")
        case .channels:
            self.feedItem.imageView.image = UIImage(systemName: "square.stack")
            self.profileItem.imageView.image = UIImage(systemName: "person.crop.circle")
            self.channelsItem.imageView.image = UIImage(systemName: "bubble.left.and.bubble.right.fill")
        case .profile:
            self.feedItem.imageView.image = UIImage(systemName: "square.stack")
            self.profileItem.imageView.image = UIImage(systemName: "person.crop.circle.fill")
            self.channelsItem.imageView.image = UIImage(systemName: "bubble.left.and.bubble.right")
        }
    }
}
