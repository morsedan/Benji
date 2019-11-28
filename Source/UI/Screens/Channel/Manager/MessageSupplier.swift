//
//  MessageSupplier.swift
//  Benji
//
//  Created by Benji Dodgson on 11/11/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient
import TMROFutures

class MessageSupplier {

    static let shared = MessageSupplier()

    /// To paginate and keep messages sorted we need to maintain a list
    private(set) var allMessages: [Messageable] = []

    //MARK: GET MESSAGES

    func getLastMessages(for channel: TCHChannel, batchAmount: UInt = 20) -> Future<[ChannelSectionable]> {
        let promise = Promise<[ChannelSectionable]>()

        if let messagesObject = channel.messages {
            messagesObject.getLastWithCount(batchAmount) { (result, messages) in
                if let msgs = messages, let members = channel.members {
                    self.getMembersArray(from: members)
                        .observe { (membersResult) in
                            switch membersResult {
                            case .success(let membersArray):
                                let updatedMsgs = self.mapConsumption(to: msgs, from: membersArray)
                                let sections = self.mapMessagesToSections(for: updatedMsgs, in: .channel(channel))
                                promise.resolve(with: sections)
                            case .failure(_):
                                promise.reject(with: ClientError.generic)
                            }
                    }
                    promise.resolve(with: self.mapMessagesToSections(for: msgs, in: .channel(channel)))
                } else {
                    promise.reject(with: ClientError.generic)
                }
            }
        } else {
            promise.reject(with: ClientError.generic)
        }

        return promise
    }

    func getMessages(before index: UInt,
                     batchAmount: UInt = 20,
                     for channel: TCHChannel) -> Future<[ChannelSectionable]> {

        let promise = Promise<[ChannelSectionable]>()

        if let messagesObject = channel.messages {
            messagesObject.getBefore(index, withCount: batchAmount) { (result, messages) in
                if let msgs = messages, let members = channel.members {
                    self.getMembersArray(from: members)
                        .observe { (membersResult) in
                            switch membersResult {
                            case .success(let membersArray):
                                let updatedMsgs = self.mapConsumption(to: msgs, from: membersArray)
                                self.allMessages.insert(contentsOf: updatedMsgs, at: 0)
                                let sections = self.mapMessagesToSections(for: updatedMsgs, in: .channel(channel))
                                promise.resolve(with: sections)
                            case .failure(_):
                                promise.reject(with: ClientError.generic)
                            }
                    }
                } else {
                    promise.reject(with: ClientError.generic)
                }
            }
        } else {
            promise.reject(with: ClientError.generic)
        }

        return promise
    }

    func mapMessagesToSections(for messages: [Messageable], in channelable: ChannelType) -> [ChannelSectionable] {

        var sections: [ChannelSectionable] = []

        messages.forEach { (message) in

            // Determine if the message is a part of the latest channel section
            let messageCreatedAt = message.createdAt

            if let latestSection = sections.last, latestSection.date.isSameDay(as: messageCreatedAt) {
                // If the message fits into the latest section, then just append it
                latestSection.items.append(message)
            } else {
                // Otherwise, create a new section with the date of this message
                let section = ChannelSectionable(date: messageCreatedAt.beginningOfDay,
                                                 items: [message],
                                                 channelType: channelable)
                sections.append(section)
            }
        }

        return sections
    }

    func setLastConsumedMessage(index: Int) {

        
        
    }

    private func getMembersArray(from members: TCHMembers) -> Future<[TCHMember]> {
        let promise = Promise<[TCHMember]>()

        members.members { (result, pag) in
            if let channelMembers = pag?.items() {
                promise.resolve(with: channelMembers)
            } else {
                promise.reject(with: ClientError.generic)
            }
        }

        return promise
    }

    private func mapConsumption(to messages: [Messageable], from members: [TCHMember]) -> [Messageable] {
        var updatedMessages: [Messageable] = []

        messages.forEach { (message) in
            var consumers: [Avatar] = []
            members.forEach { (member) in
                if let identity = member.identity,
                    identity != message.authorID,
                    let messageIndex = message.messageIndex,
                    let lastIndex = member.lastConsumedMessageIndex,
                    lastIndex.intValue >= messageIndex.intValue {

                    consumers.append(member)
                }
            }
            
            message.hasBeenConsumedBy = consumers
            updatedMessages.append(message)
        }
        return updatedMessages
    }
}
