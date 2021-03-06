//
//  ChannelManager+Extensions.swift
//  Benji
//
//  Created by Benji Dodgson on 4/27/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient

typealias CompletionHandler = (_ success: Bool, _ error: Error?) -> Void
typealias ClientCompletion = (_ client: TwilioChatClient, _ error: Error?) -> Void
typealias ChannelsCompletion = (_ channel: [TCHChannel], _ error: Error?) -> Void
typealias ChannelCreationCompletion = (_ channel: TCHChannel?, _ error: Error?) -> Void

struct ChatClientUpdate {
    var client: TwilioChatClient
    var status: Status

    enum Status {
        case connectionState(TCHClientConnectionState)
        case userUpdate(TCHUser, TCHUserUpdate)
        case toastSubscribed
        case toastRegistrationFailed(TCHError)
        case error(TCHError)
    }
}

struct ChannelUpdate {
    var channel: TCHChannel
    var status: Status

    enum Status {
        case added
        case changed
        case deleted
    }
}

struct ChannelSyncUpdate {
    var channel: TCHChannel
    var status: TCHChannelSynchronizationStatus
}

struct MessageUpdate {
    var channel: TCHChannel
    var message: TCHMessage
    var status: Status

    enum Status {
        case added
        case changed
        case deleted
        case toastReceived
    }
}

struct ChannelMemberUpdate {
    var channel: TCHChannel
    var member: TCHMember
    var status: Status

    enum Status {
        case joined
        case left
        case changed
        case typingEnded
        case typingStarted
    }
}

extension ChannelManager: TwilioChatClientDelegate {

    //MARK: CLIENT UDPATES

    func chatClient(_ client: TwilioChatClient, synchronizationStatusUpdated status: TCHClientSynchronizationStatus) {
        self.clientSyncUpdate.value = status
    }

    func chatClient(_ client: TwilioChatClient, connectionStateUpdated state: TCHClientConnectionState) {
        self.clientUpdate.value = ChatClientUpdate(client: client, status: .connectionState(state))
    }

    func chatClient(_ client: TwilioChatClient, user: TCHUser, updated: TCHUserUpdate) {
        self.clientUpdate.value = ChatClientUpdate(client: client, status: .userUpdate(user, updated))
    }

    func chatClientToastSubscribed(_ client: TwilioChatClient!) {
        self.clientUpdate.value = ChatClientUpdate(client: client, status: .toastSubscribed)
    }

    func chatClient(_ client: TwilioChatClient!, toastRegistrationFailedWithError error: TCHError!) {
        self.clientUpdate.value = ChatClientUpdate(client: client, status: .toastRegistrationFailed(error))
    }

    func chatClient(_ client: TwilioChatClient, errorReceived error: TCHError) {
        self.clientUpdate.value = ChatClientUpdate(client: client, status: .error(error))
    }

    //MARK: CHANNEL UPDATES

    func chatClient(_ client: TwilioChatClient, channelAdded channel: TCHChannel) {
        ToastScheduler.shared.schedule(toastType: .channel(channel))
        self.channelsUpdate.value = ChannelUpdate(channel: channel, status: .added)
    }

    func chatClient(_ client: TwilioChatClient!, channelChanged channel: TCHChannel!) {
        self.channelsUpdate.value = ChannelUpdate(channel: channel, status: .changed)
    }

    func chatClient(_ client: TwilioChatClient, channelDeleted channel: TCHChannel) {
        self.channelsUpdate.value = ChannelUpdate(channel: channel, status: .deleted)
    }

    func chatClient(_ client: TwilioChatClient, channel: TCHChannel, synchronizationStatusUpdated status: TCHChannelSynchronizationStatus) {
        self.channelSyncUpdate.value = ChannelSyncUpdate(channel: channel, status: status)
    }

    //MARK: MEMBER UDPATES

    func chatClient(_ client: TwilioChatClient, channel: TCHChannel, memberLeft member: TCHMember) {
        self.memberUpdate.value = ChannelMemberUpdate(channel: channel, member: member, status: .left)
        self.handle(member: member, in: channel, status: .left)
    }

    func chatClient(_ client: TwilioChatClient, channel: TCHChannel, memberJoined member: TCHMember) {
        self.memberUpdate.value = ChannelMemberUpdate(channel: channel, member: member, status: .joined)
        self.handle(member: member, in: channel, status: .left)
    }

    func chatClient(_ client: TwilioChatClient!, channel: TCHChannel!, memberChanged member: TCHMember!) {
        self.memberUpdate.value = ChannelMemberUpdate(channel: channel, member: member, status: .changed)
    }

    func chatClient(_ client: TwilioChatClient, typingEndedOn channel: TCHChannel, member: TCHMember) {
        self.memberUpdate.value = ChannelMemberUpdate(channel: channel, member: member, status: .typingEnded)
    }

    func chatClient(_ client: TwilioChatClient, typingStartedOn channel: TCHChannel, member: TCHMember) {
        self.memberUpdate.value = ChannelMemberUpdate(channel: channel, member: member, status: .typingStarted)
        self.handle(member: member, in: channel, status: .typingStarted)
    }

    private func handle(member: TCHMember, in channel: TCHChannel, status: ChannelMemberUpdate.Status) {

        member.getMemberAsUser()
            .observeValue { (user) in
                switch status {
                case .joined:
                    ToastScheduler.shared.schedule(toastType: .userStatusUpdateInChannel(user, status, channel))
                case .left:
                    ToastScheduler.shared.schedule(toastType: .userStatusUpdateInChannel(user, status, channel))
                case .typingStarted:
                    if channel != ChannelManager.shared.activeChannel.value {
                        ToastScheduler.shared.schedule(toastType: .userStatusUpdateInChannel(user, status, channel))
                    }
                default:
                    break
                }
        }
    }

    //MARK: MESSAGE UPDATES

    func chatClient(_ client: TwilioChatClient, channel: TCHChannel, messageAdded message: TCHMessage) {
        self.messageUpdate.value = MessageUpdate(channel: channel, message: message, status: .added)

        if ChannelManager.shared.activeChannel.value == nil {
            if message.isFromCurrentUser, message.context == .status {
                // Don't send toast for status messages from current user
            } else {
                ToastScheduler.shared.schedule(toastType: .message(message, channel))
            }
        }
    }

    func chatClient(_ client: TwilioChatClient!, channel: TCHChannel!, messageChanged message: TCHMessage!) {
        self.messageUpdate.value = MessageUpdate(channel: channel, message: message, status: .changed)
    }

    func chatClient(_ client: TwilioChatClient, channel: TCHChannel, messageDeleted message: TCHMessage) {
        self.messageUpdate.value = MessageUpdate(channel: channel, message: message, status: .deleted)
    }

    func chatClient(_ client: TwilioChatClient!, toastReceivedOn channel: TCHChannel!, message: TCHMessage!) {
        self.messageUpdate.value = MessageUpdate(channel: channel, message: message, status: .toastReceived)
    }
}

