//
//  FeedCell.swift
//  Benji
//
//  Created by Benji Dodgson on 7/28/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Koloda

class FeedView: KolodaView {

    let defaultTopOffset: CGFloat = 20
    let defaultHorizontalOffset: CGFloat = 100
    let defaultHeightRatio: CGFloat = 1.25
    let backgroundCardHorizontalMarginMultiplier: CGFloat = 0.25
    let backgroundCardScalePercent: CGFloat = 1.5

    let textView = FeedTextView()
    let avatarView = AvatarView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }

    private func initialize() {
        self.addSubview(self.textView)
        self.addSubview(self.avatarView)

        self.set(backgroundColor: .background3)
        self.roundCorners()
        self.addShadow(withOffset: 20)
    }

    func configure(with item: FeedType?) {
        guard let feedItem = item else { return }

        switch feedItem {
        case .system(let systemMessage):
            self.textView.set(localizedText: systemMessage.body)
            self.avatarView.set(avatar: systemMessage.avatar)
        case .message(_):
            break
        case .channelInvite(_):
            self.textView.set(localizedText: "You have a new channel to join")
            self.avatarView.set(avatar: Lorem.avatar())
        }
    }

    override func frameForCard(at index: Int) -> CGRect {

        switch index {
        case 0:
            let topOffset: CGFloat = self.defaultTopOffset
            let xOffset: CGFloat = self.defaultHorizontalOffset
            let width = (self.frame).width - 2 * self.defaultHorizontalOffset
            let height = width * self.defaultHeightRatio
            let yOffset: CGFloat = topOffset
            let frame = CGRect(x: xOffset, y: yOffset, width: width, height: height)
            return frame
        case 1:
            let horizontalMargin = -self.bounds.width * self.backgroundCardHorizontalMarginMultiplier
            let width = self.bounds.width * self.backgroundCardScalePercent
            let height = width * self.defaultHeightRatio
            return CGRect(x: horizontalMargin, y: 0, width: width, height: height)
        default:
            return .zero
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.textView.size = CGSize(width: self.proportionalWidth, height: self.height * 0.5)
        self.textView.top = 40
        self.textView.centerOnX()

        self.avatarView.size = CGSize(width: 24, height: 24)
        self.avatarView.bottom = self.height - 100
        self.avatarView.centerOnX()
    }
}
