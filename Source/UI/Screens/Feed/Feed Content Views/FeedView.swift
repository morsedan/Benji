//
//  FeedCell.swift
//  Benji
//
//  Created by Benji Dodgson on 7/28/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Koloda

protocol FeedViewDelegate: class {
    func feed(_ view: FeedView, didComplete: Bool)
}

class FeedView: View {

    private let container = View()

    lazy var introView = FeedIntroView()
    lazy var routineView = FeedRoutineView()
    lazy var inviteView = FeedChannelInviteView()
    lazy var unreadView = FeedUnreadView()
    lazy var needInvitesView = FeedInviteView()
    lazy var notificationsView = FeedNotificationPermissionsView()

    var didSelect: CompletionOptional = nil
    var didComplete: CompletionOptional = nil

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
        case .system(_):
            break
        case .unreadMessages(let channel, let count):
            self.container.addSubview(self.unreadView)
            self.unreadView.configure(with: channel, count: count)
            self.unreadView.didSelect = { [unowned self] in
                self.didSelect?()
            }
        case .channelInvite(let channel):
            self.container.addSubview(self.inviteView)
            self.inviteView.configure(with: channel)
            self.inviteView.didSelect = { [unowned self] in
                self.didSelect?()
            }
        case .inviteAsk:
            self.container.addSubview(self.needInvitesView)
            self.needInvitesView.button.onTap { [unowned self] (tap) in
                self.didComplete?()
            }
        case .rountine:
            self.container.addSubview(self.routineView)
            self.routineView.button.onTap { [unowned self] (tap) in
                self.didSelect?()
            }
        case .notificationPermissions:
            self.container.addSubview(self.notificationsView)
            self.notificationsView.didGivePermission = { [unowned self] in
                self.didComplete?()
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
