//
//  FeedSupplier.swift
//  Benji
//
//  Created by Benji Dodgson on 11/16/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TMROFutures

class FeedSupplier {

    static let shared = FeedSupplier()

    private(set) var items: [FeedType] = []

    func getItems() -> Future<[FeedType]> {
        return self.getIntroCard()
    }

    private func getIntroCard() -> Future<[FeedType]> {
        let promise = Promise<[FeedType]>()

        let message = Lorem.systemMessage()
        let feedItem = FeedType.system(message)
        self.items.append(feedItem)
        self.getInvitationRecommendations(with: promise)
        return promise
    }

    func getInvitationRecommendations(with promise: Promise<[FeedType]>) {
        let item = FeedType.inviteAsk
        self.items.append(item)
        self.getInvitedChannels(with: promise)
    }

    func getInvitedChannels(with promise: Promise<[FeedType]>) {

        ChannelManager.shared.subscribedChannels.forEach { (channel) in
            if channel.status == .invited {
                self.items.append(.channelInvite(channel))
            }
        }

        promise.resolve(with: self.items)
    }
}
