//
//  ChannelSupplier.swift
//  Benji
//
//  Created by Benji Dodgson on 11/11/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient
import TMROFutures
import TMROLocalization

class ChannelSupplier {

    // MARK: CREATION

    static func createChannel(channelName: String,
                              channelDescription: String,
                              type: TCHChannelType,
                              attributes: NSMutableDictionary = [:]) -> Future<TCHChannel> {

        guard let client = ChannelManager.shared.client else {
            let errorMessage = "Unable to create channel. Twilio client uninitialized"
            return Promise<TCHChannel>(error: ClientError.apiError(detail: errorMessage))
        }

        attributes[ChannelKey.description.rawValue] = channelDescription

        return client.createChannel(channelName: "#" + channelName,
                                    uniqueName: UUID().uuidString,
                                    type: type,
                                    attributes: attributes)
    }

    func delete(channel: TCHChannel, completion: @escaping CompletionHandler) {
        channel.destroy { result in
            completion(result.isSuccessful() , result.error)
        }
    }

    // MARK: GETTERS

    static func getChannel(withSID channelSID: String) -> TCHChannel? {
        return ChannelManager.shared.subscribedChannels.first(where: { (channel) in
            return channel.sid == channelSID
        })
    }

    /// Channels can only be found by user if they have already joined or are invited
    static func findChannel(with channelId: String) -> Future<TCHChannel> {

        let promise = Promise<TCHChannel>()
        ChannelManager.shared.client?.findChannel(with: channelId)
        .observe(with: { (result) in
            switch result {
            case .success(let channel):
                promise.resolve(with: channel)
            case .failure(let error):
                promise.reject(with: error)
            }
        })

        return promise
    }

    static func getChannel(containingMember userID: String) -> TCHChannel? {
        return ChannelManager.shared.subscribedChannels.first(where: { (channel) -> Bool in
            return channel.member(withIdentity: userID) != nil
        })
    }
}
