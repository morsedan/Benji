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

    let channels: [ChannelType] = {
        // TODO: DELETE THESE FAKE MESSAGES
        var items: [ChannelType] = []
        for _ in 0...10 {
            items.append(.system(Lorem.systemMessage()))
        }
        return items
    }()

    var channelFilter: String? {
        didSet {
            self.loadChannels()
        }
    }

    init(with delegate: ChannelsViewControllerDelegate) {
        self.delegate = delegate
        let collectionView = ChannelsCollectionView()
        super.init(with: collectionView)
        self.view.set(backgroundColor: .red)
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
                self.manager.append(item: .channel(channelsUpdate.channel))
            case .changed:
                self.manager.update(item: .channel(channelsUpdate.channel))
            case .deleted:
                self.manager.delete(item: .channel(channelsUpdate.channel))
            }
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
                //self.loadTestChannels()
                self.loadChannels()
            case .failed:
                break
            @unknown default:
                break
            }
            }.start()
    }

    private func loadChannels() {

        let allChannels = self.channels // ChannelManager.shared.channelTypes
        if let channelFilter = self.channelFilter {

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
            self.manager.set(newItems: allChannels)
        }
    }

    private func loadTestChannels() {
        var items: [ChannelType] = []
        for _ in 0...10 {
            items.append(.system(Lorem.systemMessage()))
        }
        self.manager.set(newItems: items)
    }
}
