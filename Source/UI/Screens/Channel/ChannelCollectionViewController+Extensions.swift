//
//  ChannelCollectionViewController+Extensions.swift
//  Benji
//
//  Created by Benji Dodgson on 7/5/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient

extension ChannelCollectionViewController {

    func loadMessages(for type: ChannelType) {

        switch type {
        case .system( _ ):
            self.loadTestMessages()
        case .channel(let channel):
            ChannelManager.shared.selectedChannel = channel
            self.loadChannelMessages(with: channel)
        }
    }

    private func loadChannelMessages(with channel: TCHChannel) {
        self.manager.reset()

        guard let allMessages = ChannelManager.shared.selectedChannel?.messages else { return }

        allMessages.getLastWithCount(100) { (result, messages) in
            guard let strongMessages = messages, let last = strongMessages.last, let lastIndex = last.index else {
                return
            }

            let messageTypes: [MessageType] = strongMessages.map({ (message) -> MessageType in
                return .message(message)
            })
            //self.manager.set(newItems: messageTypes)
            self.collectionView.scrollToBottom()
        }
    }

    private func loadTestMessages() {
        self.manager.set(newSections: Lorem.systemSections())
        delay(0.5) { [weak self] in
            guard let `self` = self else { return }
            self.collectionView.scrollToBottom()
        }
    }

    func subscribeToClient() {
        ChannelManager.shared.clientUpdate.producer.on { [weak self] (update) in
            guard let `self` = self,
                let clientUpdate = update,
                case .sync(let status) = clientUpdate.status else { return }

            switch status {
            case .started, .channelsListCompleted:
                self.loadingView.startAnimating()
            case .completed:
                self.loadingView.stopAnimating()
            case .failed:
                self.loadingView.stopAnimating()
            @unknown default:
                break
            }
            }
            .start()
    }

    func subscribeToUpdates() {

        ChannelManager.shared.messageUpdate.producer.on { [weak self] (update) in
            guard let `self` = self else { return }

            guard let channelUpdate = update, channelUpdate.channel == ChannelManager.shared.selectedChannel else { return }

            switch channelUpdate.status {
            case .added:
                self.manager.append(item: .message(channelUpdate.message))
                runMain {
                    self.collectionView.scrollToBottom()
                }
            // Add check here for last message not from user and its attributes to find quick messsages
            case .changed:
                self.manager.update(item: .message(channelUpdate.message))
            case .deleted:
                self.manager.delete(item: .message(channelUpdate.message))
            case .toastReceived:
                break
            }
            }.start()

        ChannelManager.shared.memberUpdate.producer.on { [weak self] (update) in
            guard let `self` = self else { return }

            guard let memberUpdate = update, memberUpdate.channel == ChannelManager.shared.selectedChannel else { return }

            switch memberUpdate.status {
            case .joined:
                break
            case .left:
                break
            case .changed:
                self.loadChannelMessages(with: memberUpdate.channel)
            case .typingEnded:
                break
//                if let memberID = memberUpdate.member.identity, memberID != User.me?.id {
//                    self.hideStatusUpdate()
//                }
            case .typingStarted:
                break
//                if let memberID = memberUpdate.member.identity, memberID != User.me?.id {
//                    self.showTyping(for: memberUpdate.member)
//                }
            }
            }.start()

        ChannelManager.shared.channelsUpdate.producer.on { [weak self] (update) in
            guard let `self` = self else { return }

            guard let channelsUpdate = update, channelsUpdate.channel == ChannelManager.shared.selectedChannel
                else { return }

            switch channelsUpdate.status {
            case .added:
                break
            case .changed:
                break
            case .deleted:
                break 
                //self.manager.reset()
            case .syncUpdate(let syncStatus):
                switch syncStatus {
                case .none, .identifier, .metadata, .failed:
                    break
                case .all:
                    self.loadChannelMessages(with: channelsUpdate.channel)
                @unknown default:
                    break
                }
                break
            }
            }.start()
    }
}
