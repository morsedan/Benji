//
//  ChannelManager.swift
//  Benji
//
//  Created by Benji Dodgson on 1/29/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient
import ReactiveSwift

class ChannelManager: NSObject {

    static let shared = ChannelManager()
    var client: TwilioChatClient?

    var clientUpdate = MutableProperty<ChatClientUpdate?>(nil)
    var channelsUpdate = MutableProperty<ChannelUpdate?>(nil)
    var messageUpdate = MutableProperty<MessageUpdate?>(nil)
    var memberUpdate = MutableProperty<ChannelMemberUpdate?>(nil)

    var isSynced: Bool {
        guard let client = self.client else { return false }
        if client.synchronizationStatus == .completed || client.synchronizationStatus == .channelsListCompleted {
            return true
        }

        return false
    }

    func initialize(token: String, completion: @escaping ClientCompletion) {
//        TwilioChatClient.chatClient(withToken: token, properties: nil, delegate: self, completion: { [weak self] (result, client) in
//            guard let `self` = self else { return }
//            if let strongClient = client {
//                self.client = strongClient
//                completion(strongClient, nil)
//            }
//        })
    }

    func update(token: String, completion: @escaping CompletionHandler) {
        guard let client = self.client else { return }
        client.updateToken(token, completion: { (result) in
            completion(true, nil)
        })
    }

    //MARK: HELPERS

    func getChannels(completion: @escaping ChannelsCompletion) {
        guard let client = self.client,
            let channels = client.channelsList() else { return }

        let subscribedChannels = channels.subscribedChannels()
        completion(subscribedChannels, nil)
    }

    func createChannel(channelName: String,
                       uniqueName: String,
                       type: TCHChannelType,
                       attribtutes: Dictionary<String, Any> = [:],
                       completion: @escaping ChannelCreationCompletion) {
        guard let client = self.client, let channels = client.channelsList() else { return }

        self.hasChannel(with: uniqueName) { (channel) in
            if let strongChannel = channel {
                completion(strongChannel, nil)
            } else {
                let options = [
                    TCHChannelOptionFriendlyName: channelName,
                    TCHChannelOptionUniqueName: uniqueName,
                    TCHChannelOptionType: type.rawValue,
                    TCHChannelOptionAttributes: attribtutes,
                    ] as [String : Any]

                channels.createChannel(options: options, completion: { result, channel in
                    completion(channel, result.error)
                })
            }
        }
    }

    func delete(channel: TCHChannel, completion: @escaping CompletionHandler) {
        channel.destroy { result in
            completion(result.isSuccessful() , result.error)
        }
    }

    func joinChannel(sid: String, completion: @escaping ClientCompletion) {
        guard let client = self.client, let channels = client.channelsList() else { return }

        channels.channel(withSidOrUniqueName: sid, completion: { (result, channel) in
            guard let strongChannel = channel else {
                completion(client, result.error)
                return
            }

            if result.isSuccessful(), strongChannel.status != .joined {
                strongChannel.join(completion: { (result) in
                    completion(client, result.error)
                })
            } else {
                completion(client, result.error)
            }
        })
    }

    func sendMessage(channel: TCHChannel, body: String, attributes: Dictionary<String, Any>) {
        if let messages = channel.messages {
            let messageOptions = TCHMessageOptions().withBody(body)
            messages.sendMessage(with: messageOptions, completion: { (result, message) in

            })
        }
    }

    func getLatestMessages(channel: TCHChannel, count: Int) {
        guard let messages = channel.messages else { return }

        messages.getLastWithCount(UInt(count), completion: { (result, newMessages) in

        })
    }

    func sendInvite(channel: TCHChannel, identity: String) {
        guard let members = channel.members else { return }

        members.invite(byIdentity: identity) { result in

        }
    }

    func update(channel: TCHChannel, withAttributes: Any) {

    }

    func hasChannel(with name: String, completion: @escaping (TCHChannel?) -> Void) {
        guard let client = self.client, let channels = client.channelsList() else {
            completion(nil)
            return
        }

        channels.channel(withSidOrUniqueName: name) { (result, channel) in
            completion(channel)
        }
    }
}
