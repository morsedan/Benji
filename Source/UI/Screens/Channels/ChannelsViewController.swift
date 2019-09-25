//
//  ChannelsViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 2/3/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient

protocol ChannelsViewControllerDelegate: class {
    func channelsView(_ controller: ChannelsViewController, didSelect channelType: ChannelType)
}

class ChannelsViewController: CollectionViewController<ChannelCell, ChannelsCollectionViewManager> {

    unowned let delegate: ChannelsViewControllerDelegate

    // A cache of the all the user's current channels and system messages,
    // sorted by date updated, with newer channels at the beginning.
    lazy var channelTypeCache: [ChannelType] = []
    var channelFilter: String? {
        didSet {
            self.loadFilteredChannels()
        }
    }

    init(with delegate: ChannelsViewControllerDelegate) {
        self.delegate = delegate
        let collectionView = ChannelsCollectionView()

        super.init(with: collectionView)

        self.subscribeToUpdates()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didSelect(item: ChannelType, at indexPath: IndexPath) {
        super.didSelect(item: item, at: indexPath)
        self.delegate.channelsView(self, didSelect: item)
    }

    func animateIn(completion: @escaping CompletionHandler) {
        let animator = UIViewPropertyAnimator(duration: Theme.animationDuration,
                                              curve: .easeInOut) {
                                                self.view.transform = CGAffineTransform.identity
                                                self.view.alpha = 1
        }
        animator.addCompletion { (position) in
            if position == .end {
                completion(true, nil)
            }
        }

        animator.startAnimation()
    }

    func animateOut(completion: @escaping CompletionHandler) {
        let animator = UIViewPropertyAnimator(duration: Theme.animationDuration,
                                              curve: .easeInOut) {
                                                self.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                                                self.view.alpha = 0
                                                self.view.setNeedsLayout()
        }
        animator.addCompletion { (position) in
            if position == .end {
                completion(true, nil)
            }
        }

        animator.startAnimation()
    }

    func subscribeToUpdates() {
        ChannelManager.shared.channelUpdate.producer.on { [weak self] (update) in
            guard let `self` = self else { return }

            guard let channelsUpdate = update else { return }

            switch channelsUpdate.status {
            case .added:
                // Do nothing. We only want to show channels that are being searched for.
                break
            case .changed:
                self.manager.update(item: .channel(channelsUpdate.channel))
            case .deleted:
                self.manager.delete(item: .channel(channelsUpdate.channel))
            }

            // Reload the cache because changes to the channel list have occurred.
            self.channelTypeCache = self.getChannelsSortedByUpdateDate()
            }.start()

        ChannelManager.shared.clientSyncUpdate.producer.on { [weak self] (update) in
            guard let `self` = self else { return }

            guard let clientUpdate = update else { return }

            switch clientUpdate {
            case .started:
                break
            case .channelsListCompleted:
                break
            case .completed:
                self.channelTypeCache = self.getChannelsSortedByUpdateDate()
                self.loadFilteredChannels()
            case .failed:
                break
            @unknown default:
                break
            }
            }.start()
    }

    private func getChannelsSortedByUpdateDate() -> [ChannelType] {
        let channelTypes = ChannelManager.shared.channelTypes
        return channelTypes.sorted { (channel1, channel2) -> Bool in
            channel1.dateUpdated > channel2.dateUpdated
        }
    }

    private func loadFilteredChannels() {
        let allChannels = self.channelTypeCache

        if let channelFilter = self.channelFilter, !channelFilter.isEmpty {

            let filteredChannels = allChannels.filter { (channelType) in
                switch channelType {
                case .system(let systemMessage):
                    return systemMessage.avatar.firstName.contains(channelFilter)
                case .channel(let channel):
                    return channel.friendlyName?.contains(channelFilter) ?? false
                }
            }

            self.manager.set(newItems: filteredChannels)
        } else {
            // If no filter, get the first three most recently updated channels.
            let filteredChannels: [ChannelType] = Array(allChannels.prefix(3))
            self.manager.set(newItems: filteredChannels)
        }
    }
}
