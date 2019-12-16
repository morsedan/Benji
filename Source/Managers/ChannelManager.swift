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
import Parse

class ChannelManager: NSObject {

    static let shared = ChannelManager()
    var client: TwilioChatClient?

    var activeChannel = MutableProperty<TCHChannel?>(nil)
    var clientSyncUpdate = MutableProperty<TCHClientSynchronizationStatus?>(nil)
    var clientUpdate = MutableProperty<ChatClientUpdate?>(nil)
    var channelSyncUpdate = MutableProperty<ChannelSyncUpdate?>(nil)
    var channelsUpdate = MutableProperty<ChannelUpdate?>(nil)
    var messageUpdate = MutableProperty<MessageUpdate?>(nil)
    var memberUpdate = MutableProperty<ChannelMemberUpdate?>(nil)

    var subscribedChannels: [DisplayableChannel] {
        get {
            guard let client = self.client, let channels = client.channelsList() else { return [] }
            return channels.subscribedChannels().map { (channel) -> DisplayableChannel in
                return DisplayableChannel.init(channelType: .channel(channel))
            }
        }
    }

    var isSynced: Bool {
        guard let client = self.client else { return false }
        if client.synchronizationStatus == .completed || client.synchronizationStatus == .channelsListCompleted {
            return true
        }

        return false
    }

    var isConnected: Bool {
        guard let client = self.client else { return false }
        return client.connectionState == .connected
    }

    static func initialize(token: String) {
        TwilioChatClient.chatClient(withToken: token,
                                    properties: nil,
                                    delegate: shared,
                                    completion: { (result, client) in
                                        guard let strongClient = client else { return }
                                        shared.client = strongClient
        })
    }

    func update(token: String, completion: @escaping CompletionHandler) {
        guard let client = self.client else { return }
        client.updateToken(token, completion: { (result) in
            completion(true, nil)
        })
    }
    
    //MARK: MESSAGE HELPERS

    @discardableResult
    func sendMessage(to channel: TCHChannel,
                     with body: String,
                     attributes: [String : Any] = [:]) -> Future<Messageable> {

        let message = body.extraWhitespaceRemoved()
        let promise = Promise<Messageable>()

        guard self.isConnected,
                !message.isEmpty,
                channel.status == .joined,
                let messages = channel.messages else {
                promise.reject(with: ClientError.generic)
                return promise
        }

        let messageOptions = TCHMessageOptions().withBody(body)
        messageOptions.withAttributes(attributes, completion: nil)
        messages.sendMessage(with: messageOptions) { (result, message) in
            if result.isSuccessful(), let msg = message {
                promise.resolve(with: msg)
            } else if let error = result.error {
                promise.reject(with: error)
            } else {
                promise.reject(with: ClientError.generic)
            }
        }

        return promise
    }
}
