//
//  FeedCell.swift
//  Benji
//
//  Created by Benji Dodgson on 7/28/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Koloda

class FeedView: View {

    private let container = View()

    lazy var introView = FeedIntroView()
    lazy var routineView = FeedRoutineView()
    var didSelect: () -> Void = {}

    override func initializeSubviews() {
        super.initializeSubviews()

        self.addSubview(self.container)
        self.set(backgroundColor: .background2)
        self.roundCorners()
        self.addShadow(withOffset: 20)
    }

    func configure(with item: FeedType?) {
        guard let feedItem = item else { return }

        switch feedItem {
        case .intro:
            self.container.addSubview(self.introView)
        case .system(let systemMessage):
            break
        case .unreadMessages(let channel, let count):
            break
        case .channelInvite(_):
            break
        case .inviteAsk:
            break
        case .rountine:
            self.container.addSubview(self.routineView)
            self.routineView.button.onTap { [unowned self] (tap) in
                self.didSelect()
            }
        }

        self.container.layoutNow()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let margin = Theme.contentOffset * 2
        self.container.size = CGSize(width: self.width - margin, height: self.height - margin)
        self.container.centerOnXAndY()

        if let first = self.container.subviews.first {
            first.frame = self.container.bounds
        }
    }
}
