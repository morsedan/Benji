//
//  ChannelCollectionViewController+Extensions.swift
//  Benji
//
//  Created by Benji Dodgson on 7/5/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient
import Parse

//extension ChannelCollectionViewController {
//
//    func loadMessages(for type: ChannelType) {
//
//        switch type {
//        case .system(_):
//            self.loadTestMessages()
//        case .channel(let channel):
//            self.loadChannelMessages(with: channel)
//        }
//    }
//
//    private func loadChannelMessages(with channel: TCHChannel) {
//        self.channelDataSource.reset()
//        ChannelManager.shared.selectedChannel = channel
//        ChannelManager.shared.getLastMessages(for: channel) { [unowned self] (sections) in
//            self.channelDataSource.set(newSections: sections)
//            delay(0.5, { [weak self] in
//                guard let `self` = self else { return }
//                self.collectionView.scrollToBottom()
//            })
//        }
//    }
//
//    private func loadTestMessages() {
//        self.channelDataSource.set(newSections: Lorem.systemSections())
//        delay(0.5) { [weak self] in
//            guard let `self` = self else { return }
//            self.collectionView.scrollToBottom()
//        }
//    }
//
//    func subscribeToClient() {
//        ChannelManager.shared.clientSyncUpdate.producer.on { [weak self] (update) in
//            guard let `self` = self, let clientUpdate = update else { return }
//
//            switch clientUpdate {
//            case .started, .channelsListCompleted:
//                self.loadingView.startAnimating()
//            case .completed:
//                self.loadingView.stopAnimating()
//            case .failed:
//                self.loadingView.stopAnimating()
//            @unknown default:
//                break
//            }
//        }
//        .start()
//    }
//
//    func subscribeToUpdates() {
//
//        ChannelManager.shared.messageUpdate.producer.on { [weak self] (update) in
//            guard let `self` = self else { return }
//
//            guard let channelUpdate = update, channelUpdate.channel == ChannelManager.shared.selectedChannel else { return }
//
//            switch channelUpdate.status {
//            case .added:
//                if self.collectionView.isTypingIndicatorHidden {
//                    self.channelDataSource.updateLastItem(with: channelUpdate.message)
//                    runMain {
//                        self.collectionView.scrollToBottom()
//                    }
//                } else {
//                    self.setTypingIndicatorViewHidden(true, performUpdates: { [weak self] in
//                        guard let `self` = self else { return }
//                        self.channelDataSource.updateLastItem(with: channelUpdate.message, replaceTypingIndicator: true)
//                    })
//                }
//            case .changed:
//                self.channelDataSource.update(item: channelUpdate.message)
//            case .deleted:
//                self.channelDataSource.delete(item: channelUpdate.message)
//            case .toastReceived:
//                break
//        }
//        }.start()
//
//        ChannelManager.shared.memberUpdate.producer.on { [weak self] (update) in
//            guard let `self` = self else { return }
//
//            guard let memberUpdate = update, memberUpdate.channel == ChannelManager.shared.selectedChannel else { return }
//
//            switch memberUpdate.status {
//            case .joined:
//                break
//            case .left:
//                break
//            case .changed:
//                self.loadChannelMessages(with: memberUpdate.channel)
//            case .typingEnded:
//                self.setTypingIndicatorViewHidden(true, animated: true)
//            case .typingStarted:
//                if let memberID = memberUpdate.member.identity, memberID != User.current()?.objectId {
//                    self.setTypingIndicatorViewHidden(false, performUpdates: nil)
//                }
//            }
//            }.start()
//
//        ChannelManager.shared.channelSyncUpdate.producer.on { [weak self] (update) in
//            guard let `self` = self else { return }
//
//            guard let channelsUpdate = update, channelsUpdate.channel == ChannelManager.shared.selectedChannel
//                else { return }
//
//            switch channelsUpdate.status {
//            case .none, .identifier, .metadata, .failed:
//                break
//            case .all:
//                self.loadChannelMessages(with: channelsUpdate.channel)
//            @unknown default:
//                break
//            }
//            }.start()
//    }
//
//    func setTypingIndicatorViewHidden(_ isHidden: Bool, performUpdates updates: (() -> Void)? = nil) {
//        self.setTypingIndicatorViewHidden(isHidden, animated: true, whilePerforming: updates) { [weak self] success in
//            guard let `self` = self else { return }
//            if success, self.isLastMessageVisible() == true {
//                runMain {
//                    self.collectionView.scrollToBottom()
//                }
//            }
//        }
//    }
//
//    func setTypingIndicatorViewHidden(_ isHidden: Bool,
//                                      animated: Bool,
//                                      whilePerforming updates: (() -> Void)? = nil,
//                                      completion: ((Bool) -> Void)? = nil) {
//
//        guard self.collectionView.isTypingIndicatorHidden != isHidden else {
//            completion?(false)
//            return
//        }
//
//        let section = self.collectionView.numberOfSections
//        self.collectionView.channelLayout.setTypingIndicatorViewHidden(isHidden)
//
//        if animated {
//            self.collectionView.performBatchUpdates({ [weak self] in
//                guard let `self` = self else { return }
//                self.performUpdatesForTypingIndicatorVisability(at: section)
//                updates?()
//                }, completion: completion)
//        } else {
//            self.performUpdatesForTypingIndicatorVisability(at: section)
//            updates?()
//            completion?(true)
//        }
//    }
//
//    /// Performs a delete or insert on the `ChannelCollectionView` on the provided section
//    ///
//    /// - Parameter section: The index to modify
//    private func performUpdatesForTypingIndicatorVisability(at section: Int) {
//        if self.collectionView.isTypingIndicatorHidden {
//            self.collectionView.deleteSections([section - 1])
//        } else {
//            self.collectionView.insertSections([section])
//        }
//    }
//
//    func isLastMessageVisible() -> Bool {
//        let sectionCount = self.channelDataSource.sections.count
//
//        guard sectionCount > 0, let sectionValue = self.channelDataSource.sections.last else { return false }
//
//        let lastIndexPath = IndexPath(item: sectionValue.items.count - 1, section: sectionCount - 1)
//        return self.collectionView.indexPathsForVisibleItems.contains(lastIndexPath)
//    }
//
//    func didSelectLoadMore(for messageIndex: Int) {
//        guard let channel = ChannelManager.shared.selectedChannel else { return }
//
//        ChannelManager.shared.getMessages(before: UInt(messageIndex),
//                                          extending: self.channelDataSource.sections,
//                                          for: channel) { (sections) in
//            self.channelDataSource.set(newSections: sections, keepOffset: true)
//        }
//    }
//}
