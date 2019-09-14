//
//  ChannelDetailBar.swift
//  Benji
//
//  Created by Benji Dodgson on 7/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient
import Parse

protocol ChannelDetailBarDelegate: class {
    func channelDetailBarDidTapClose(_ view: ChannelDetailBar)
    func channelDetailBarDidTapMenu(_ view: ChannelDetailBar)
}

class ChannelDetailBar: View {

    private(set) var titleLabel = RegularBoldLabel()
    private(set) var stackedAvatarView = StackedAvatarView()
    private let closeButton = Button()
    private let titleButton = Button()
    private let selectionFeedback = UIImpactFeedbackGenerator(style: .light)

    let channelType: ChannelType

    unowned let delegate: ChannelDetailBarDelegate

    init(with channelType: ChannelType, delegate: ChannelDetailBarDelegate) {
        self.delegate = delegate
        self.channelType = channelType
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initialize() {
        super.initialize()

        self.addSubview(self.titleLabel)
        self.addSubview(self.titleButton)
        self.titleButton.onTap { [unowned self] (tap) in
            self.delegate.channelDetailBarDidTapMenu(self)
        }

        self.addSubview(self.stackedAvatarView)
        self.addSubview(self.closeButton)
        self.closeButton.set(style: .icon(image: #imageLiteral(resourceName: "down_arrow")))
        self.closeButton.onTap { [unowned self] (tap) in
            self.delegate.channelDetailBarDidTapClose(self)
        }

        switch self.channelType {
        case .system(let message):
            self.setLayout(for: message)
        case .channel(let channel):
            self.setLayout(for: channel)
        }

        self.subscribeToUpdates()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.closeButton.size = CGSize(width: 20, height: 20)
        self.closeButton.right = self.width - 16
        self.closeButton.centerOnY()

        self.stackedAvatarView.left = 36
        self.stackedAvatarView.centerOnY()

        let titleWidth = self.width - self.stackedAvatarView.width - self.closeButton.width - 44
        self.titleLabel.setSize(withWidth: titleWidth)
        self.titleLabel.left = self.stackedAvatarView.right + 10
        self.titleLabel.centerOnY()

        self.titleButton.size = CGSize(width: self.titleLabel.width, height: self.height)
        self.titleButton.left = self.titleLabel.left
        self.titleButton.centerOnY()
    }

    func setLayout(for system: SystemMessage) {
        self.set(text: system.context.text)
        self.set(avatars: [system.avatar])
    }

    func setLayout(for channel: TCHChannel) {
        self.updateFriendlyName(for: channel)
        self.updateMembers(for: channel)
    }

    private func updateFriendlyName(for channel: TCHChannel) {
        if let name = channel.friendlyName {
            self.set(text: name)
        }
    }

    private func updateMembers(for channel: TCHChannel) {
        if let members = channel.members {
            members.members { (result, paginator) in
                guard result.isSuccessful(), let pag = paginator else { return }
                let membersExcludingCurrent = pag.items().filter({ (member) -> Bool in
                    return member.identity != PFUser.current.objectId
                })
                self.set(avatars: membersExcludingCurrent)
            }
        }
    }

    private func set(avatars: [Avatar]) {
        self.stackedAvatarView.configure(items: avatars)
    }

    private func set(text: Localized) {
        self.titleLabel.set(text: text)
        self.layoutNow()
    }

    private func subscribeToUpdates() {

        ChannelManager.shared.channelSyncUpdate.producer.on { [weak self] (update) in
            guard let `self` = self else { return }

            guard let channelsUpdate = update, channelsUpdate.channel == ChannelManager.shared.selectedChannel
                else { return }

            switch channelsUpdate.status {
            case .none, .identifier, .metadata, .failed:
                break
            case .all:
                self.updateMembers(for: channelsUpdate.channel)
                self.updateFriendlyName(for: channelsUpdate.channel)
            @unknown default:
                break
            }
            }.start()
    }
}
