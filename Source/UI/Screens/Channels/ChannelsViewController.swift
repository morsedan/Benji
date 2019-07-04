//
//  ChannelsViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 2/3/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient

class ChannelsViewController: CollectionViewController<ChannelCell, ChannelsCollectionViewManager> {

    init() {
        let collectionView = ChannelsCollectionView()
        super.init(with: collectionView)
        self.view.set(backgroundColor: .clear)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadChannels()
    }

    private func loadChannels() {
        var items: [ChannelType] = []
        for _ in 0...10 {
            items.append(.system(Lorem.systemMessage()))
        }
        self.manager.set(newItems: items)
    }

    override func didSelect(item: ChannelType, at indexPath: IndexPath) {
        let channelVC = ChannelViewController()
        self.present(channelVC, animated: true) {
            channelVC.loadMessages(for: item)
        }
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
}
