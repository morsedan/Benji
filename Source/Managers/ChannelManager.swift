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

    var clientSyncUpdate = MutableProperty<TCHClientSynchronizationStatus?>(nil)
    var clientUpdate = MutableProperty<ChatClientUpdate?>(nil)
    var channelSyncUpdate = MutableProperty<ChannelSyncUpdate?>(nil)
    var channelUpdate = MutableProperty<ChannelUpdate?>(nil)
    var messageUpdate = MutableProperty<MessageUpdate?>(nil)
    var memberUpdate = MutableProperty<ChannelMemberUpdate?>(nil)

//    lazy var channelTypes: [ChannelType] = {
//        // TODO: DELETE THESE FAKE MESSAGES
//        var items: [ChannelType] = []
//        for _ in 0...10 {
//            items.append(.system(Lorem.systemMessage()))
//        }
//        return items
//    }()

    var channelTypes: [ChannelType] {
        get {
            guard let client = self.client, let channels = client.channelsList() else { return [] }
            return channels.subscribedChannels().map({ (channel) -> ChannelType in
                return .channel(channel)
            })
        }
    }

    var selectedChannel: TCHChannel?
    private(set) var currentSections: [ChannelSectionType] = []

    var isSynced: Bool {
        guard let client = self.client else { return false }
        if client.synchronizationStatus == .completed || client.synchronizationStatus == .channelsListCompleted {
            return true
        }

        return false
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

    //MARK: HELPERS

    func getChannels(completion: @escaping ChannelsCompletion) {
        guard let client = self.client, let channels = client.channelsList() else { return }

        let subscribedChannels = channels.subscribedChannels()
        completion(subscribedChannels, nil)
    }

    static func createChannel(channelName: String,
                              channelDescription: String,
                              type: TCHChannelType,
                              attributes: NSMutableDictionary = [:]) -> Future<TCHChannel> {

        guard let client = self.shared.client else {
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

    //MARK: SEND MESSAGE

    func sendMessage(to channel: TCHChannel,
                     with body: String,
                     attributes: Dictionary<String, Any> = [:]) {

        let message = body.extraWhitespaceRemoved()

        guard !message.isEmpty, channel.status == .joined else { return }

        if let messages = channel.messages {
            let messageOptions = TCHMessageOptions().withBody(body)
            messageOptions.withAttributes(attributes, completion: nil)
            messages.sendMessage(with: messageOptions, completion: { (result, message) in
                
            })
        }
    }

    //MARK: GET MESSAGES

    func getAllMessages(for channel: TCHChannel,
                        batchAmount: UInt = 10,
                        completion: @escaping ([ChannelSectionType]) -> Void) {

        guard let messagesObject = channel.messages else { return }

        messagesObject.getLastWithCount(batchAmount) { (result, messages) in
            guard let strongMessages = messages else { return }

            let sections = self.mapToSections(for: strongMessages, in: channel)
            completion(sections)
        }
    }

    func getMessages(before index: UInt,
                     batchAmount: UInt = 10,
                     extending currentSections: [ChannelSectionType],
                     for channel: TCHChannel,
                     completion: @escaping ([ChannelSectionType]) -> Void) {

        guard let messagesObject = channel.messages else { return }
        var current = currentSections
        //Remove the first section
        current.remove(at: 0)

        messagesObject.getBefore(index - 1, withCount: batchAmount) { (result, messages) in
            guard let strongMessages = messages else { return }

            let new = self.mapToSections(for: strongMessages, in: channel)
            current.insert(contentsOf: new, at: 0)
            completion(current)
        }
    }

    //MARK: MAPPING

    private func mapToSections(for messages: [TCHMessage], in channel: TCHChannel) -> [ChannelSectionType] {

        guard let date = channel.dateCreatedAsDate else { return [] }

        var items: [MessageType] = []
        if let firstMessage = messages.first {
            items.append(.message(firstMessage))
        }

        let firstSection = ChannelSectionType(date: date, items: items, channelType: .channel(channel))
        var sections: [ChannelSectionType] = [firstSection]
        

        messages.forEach { (message) in

            // Determine if the message is a part of the latest channel section
            let messageCreatedAt = message.timestampAsDate ?? Date.distantPast

            if let latestSection = sections.last, latestSection.date.isSameDay(as: messageCreatedAt) {
                // If the message fits into the latest section, then just append it
                latestSection.items.append(.message(message))
            } else {
                // Otherwise, create a new section with the date of this message
                let section = ChannelSectionType(date: messageCreatedAt.beginningOfDay,
                                                 items: [.message(message)])
                sections.append(section)
            }
        }

        return sections
    }
}
