//
//  FeedSupplier.swift
//  Benji
//
//  Created by Benji Dodgson on 11/16/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TMROFutures
import ReactiveSwift

class FeedSupplier {

    static let shared = FeedSupplier()

    private(set) var items: [FeedType] = []

    func getItems() -> Future<[FeedType]> {
        return self.getIntroCard()
    }

    private func getIntroCard() -> Future<[FeedType]> {
        let promise = Promise<[FeedType]>()

        RoutineManager.shared.getRoutineNotifications()
            .observe { (result) in
                switch result {
                case .success(let routines):
                    if routines.isEmpty {

                    } else {
                        self.items.append(FeedType.intro)
                        self.getInvitationRecommendations(with: promise)
                    }

                case .failure(_):
                    self.items.append(FeedType.intro)
                    //show routine ask
                }
        }

        return promise
    }

    func showRoutineAsk(with promise: Promise<[FeedType]>) {
        self.items.append(.rountine)
        self.getInvitationRecommendations(with: promise)
    }

    func getInvitationRecommendations(with promise: Promise<[FeedType]>) {
        self.items.append(.inviteAsk)
        self.getInvitedChannels(with: promise)
    }

    func getInvitedChannels(with promise: Promise<[FeedType]>) {

        ChannelManager.shared.subscribedChannels.forEach { (channel) in
            switch channel.channelType {
            case .channel(let tchChannel):
                if tchChannel.status == .invited {
                    self.items.append(.channelInvite(tchChannel))
                }
            default:
                break
            }
        }

        self.getUnreadMessages(with: promise)
    }

    func getUnreadMessages(with promise: Promise<[FeedType]>) {

        var allProducers: SignalProducer<[FeedType], Error>

        var channelProducers: [SignalProducer<FeedType, Error>] = []
        for channel in ChannelManager.shared.subscribedChannels {
            switch channel.channelType {
            case .channel(let tchChannel):
                channelProducers.append(tchChannel.getUnconsumedCount())
            default:
                break
            }
        }

        allProducers = SignalProducer.combineLatest(channelProducers)

        var disposable: Disposable?
        disposable = allProducers
            .on(value: { (channelItems) in
                let items = channelItems.filter { (feedType) -> Bool in
                    switch feedType {
                    case .unreadMessages(_,let count):
                        return count > 0
                    default:
                        return false
                    }
                }
                self.items.append(contentsOf: items)
            })
            .on(failed: { (error) in
                disposable?.dispose()
            }, completed: {
                disposable?.dispose()
                promise.resolve(with: self.items)
            }).start()
    }
}
