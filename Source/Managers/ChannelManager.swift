//
//  ChannelManager.swift
//  Benji
//
//  Created by Benji Dodgson on 1/29/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient

enum ChannelStatus {
    case added
    case changed
    case deleted
}

protocol ChannelManagerDelegate: class {
    func didChange(status: TCHClientSynchronizationStatus)
    func didChange(status: ChannelStatus, forChannel channel: TCHChannel)
}
typealias ClientCompletion = (_ client: TwilioChatClient?, _ error: Error?) -> Void
typealias ChannelsCompletion = (_ channel: [TCHChannel]?, _ error: Error?) -> Void
typealias ChannelCompletion = (_ channel: TCHChannel?, _ error: Error?) -> Void
typealias CompletionHandler = (_ success: Bool, _ error: Error?) -> Void

class ChannelManager: NSObject {

    static let shared = ChannelManager()
    private var client: TwilioChatClient?
    weak var delegate: ChannelManagerDelegate?

    var isSynced: Bool {
        guard let client = self.client else { return false }
        if client.synchronizationStatus == .completed || client.synchronizationStatus == .channelsListCompleted {
            return true
        }

        return false
    }

    func initialize(token: String, myCompletion: @escaping ClientCompletion) {
        TwilioChatClient.chatClient(withToken: token, properties: nil, delegate: self, completion: { [weak self] (result, client) in
            guard let `self` = self else { return }
            if client != nil {
                self.client = client
                myCompletion(self.client, nil)
            }
        })
    }

    func update(token: String, completion: @escaping CompletionHandler) {
        self.client?.updateToken(token, completion: { (result) in
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

    func createAndJoin(withOptions options: Dictionary<String, Any>, completion: @escaping ChannelCompletion) {

        self.createChannel(options: options) { [weak self] (createdChannel, error) in
            guard let `self` = self else { return }
            if let channel = createdChannel, let sid = channel.sid {
                self.joinChannel(sid: sid, completion: { (joinedChannel, error) in
                    if let channel = joinedChannel {
                        completion(channel, error)
                    }
                })
            }
        }
    }

    func createChannel(options: Dictionary<String, Any>, completion: @escaping ChannelCompletion) {
        guard let client = self.client, let channels = client.channelsList() else { return }

        channels.createChannel(options: options, completion: { result, channel in
            completion(channel, result.error)
        })
    }

    func delete(channel: TCHChannel, completion: @escaping CompletionHandler) {
        channel.destroy { result in
            completion(result.isSuccessful() , result.error)
        }
    }

    func joinChannel(sid: String, completion: @escaping ChannelCompletion) {
        guard let client = self.client, let channels = client.channelsList() else { return }

        channels.channel(withSidOrUniqueName: sid, completion: { (result, channel) in

            if result.isSuccessful() {
                channel?.join(completion: { (result) in
                    completion(channel, result.error)
                })
            }
        })
    }

    func sendMessage(channel: TCHChannel, body: String, attributes: Dictionary<String, Any>) {

//        if let messages = channel.messages {
//
//            let message = messages//createMessage(withBody: body)
//            message?.setAttributes(attributes, completion: { (result) in
//
//                if let _ = result?.isSuccessful() {
//                    messages.send(message) { result in
//
//                        if let _ = result?.isSuccessful() {
//                            print("Message sent.")
//                        } else {
//                            print("Message NOT sent.")
//                        }
//                    }
//                } else {
//
//                    print("Message Attributes could not be set")
//                }
//            })
//        }
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
}

//MARK: CLIENT DELEGATE

extension ChannelManager: TwilioChatClientDelegate {

    func chatClientToastSubscribed(_ client: TwilioChatClient!) {

    }

    func chatClient(_ client: TwilioChatClient, errorReceived error: TCHError) {

    }

    func chatClient(_ client: TwilioChatClient, channelAdded channel: TCHChannel) {

        if channel.status == TCHChannelStatus.notParticipating {
            channel.join() { result in
                if result.isSuccessful() {
                    self.delegate?.didChange(status: .added, forChannel: channel)
                }
            }
        } else {
            self.delegate?.didChange(status: .added, forChannel: channel)
        }
    }

    func chatClient(_ client: TwilioChatClient!, channelChanged channel: TCHChannel!) {
        self.delegate?.didChange(status: .changed, forChannel: channel)
    }

    func chatClient(_ client: TwilioChatClient, channelDeleted channel: TCHChannel) {
        self.delegate?.didChange(status: .deleted, forChannel: channel)
    }

    func chatClient(_ client: TwilioChatClient!, toastRegistrationFailedWithError error: TCHError!) {

    }

    func chatClient(_ client: TwilioChatClient, user: TCHUser, updated: TCHUserUpdate) {

    }

    func chatClient(_ client: TwilioChatClient, channel: TCHChannel, memberLeft member: TCHMember) {

    }

    func chatClient(_ client: TwilioChatClient, channel: TCHChannel, memberJoined member: TCHMember) {

    }

    func chatClient(_ client: TwilioChatClient!, channel: TCHChannel!, memberChanged member: TCHMember!) {

    }

    func chatClient(_ client: TwilioChatClient, connectionStateUpdated state: TCHClientConnectionState) {

    }

    func chatClient(_ client: TwilioChatClient, typingEndedOn channel: TCHChannel, member: TCHMember) {

    }

    func chatClient(_ client: TwilioChatClient, channel: TCHChannel, messageAdded message: TCHMessage) {

    }

    func chatClient(_ client: TwilioChatClient, typingStartedOn channel: TCHChannel, member: TCHMember) {

    }

    func chatClient(_ client: TwilioChatClient!, channel: TCHChannel!, messageChanged message: TCHMessage!) {

    }

    func chatClient(_ client: TwilioChatClient, channel: TCHChannel, messageDeleted message: TCHMessage) {

    }

    func chatClient(_ client: TwilioChatClient!, toastReceivedOn channel: TCHChannel!, message: TCHMessage!) {

    }

    func chatClient(_ client: TwilioChatClient, synchronizationStatusUpdated status: TCHClientSynchronizationStatus) {

        switch status {

        case .started:
            print("STATUS CHANGED TO: STARTED")
        case .channelsListCompleted:
            print("STATUS CHANGED TO: CHANNEL LIST COMPLETED")
        case .completed:
            print("STATUS CHANGED TO: COMPLETED")
        case .failed:
            print("STATUS CHANGED TO: FAILED")
        }
        self.delegate?.didChange(status: status)
    }

    func chatClient(_ client: TwilioChatClient, channel: TCHChannel, synchronizationStatusUpdated status: TCHChannelSynchronizationStatus) {

    }
}

