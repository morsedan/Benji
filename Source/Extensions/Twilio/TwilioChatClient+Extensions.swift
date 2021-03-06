//
//  TwilioChatClient+Extensions.swift
//  Benji
//
//  Created by Benji Dodgson on 7/5/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TMROFutures

import TwilioChatClient

extension TwilioChatClient {

    func createChannel(channelName: String,
                       uniqueName: String,
                       type: TCHChannelType,
                       attributes: NSMutableDictionary = [:]) -> Future<TCHChannel> {

        let promise = Promise<TCHChannel>()

        guard let channels = self.channelsList() else {
            promise.reject(with: ClientError.message(detail: "There are no channels to create."))
            return promise
        }

        let options = [TCHChannelOptionFriendlyName: channelName,
                       TCHChannelOptionUniqueName: uniqueName,
                       TCHChannelOptionType: type.rawValue,
                       TCHChannelOptionAttributes: attributes] as [String : Any]

        channels.createChannel(options: options, completion: { (result, channel) in
            if let createdChannel = channel, result.isSuccessful() {
                promise.resolve(with: createdChannel)
            } else if let error = result.error {
                promise.reject(with: error)
            } else {
                promise.reject(with: ClientError.message(detail: "Channel creation failed."))
            }
        })

        return promise.withResultToast()
    }

    func findChannel(with channelId: String) -> Future<TCHChannel> {
        let promise = Promise<TCHChannel>()

        guard let channels = self.channelsList() else {
            promise.reject(with: ClientError.message(detail: "No channels were found."))
            return promise
        }

        channels.channel(withSidOrUniqueName: channelId) { (result, channel) in
            if let strongChannel = channel, result.isSuccessful() {
                promise.resolve(with: strongChannel)
            } else if let error = result.error {
                promise.reject(with: error)
            } else {
                promise.reject(with: ClientError.message(detail: "No channel with that ID was found."))
            }
        }

        return promise.withResultToast()
    }
}

