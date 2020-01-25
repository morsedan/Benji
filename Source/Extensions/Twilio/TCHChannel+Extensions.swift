//
//  TCHChannel+Extensions.swift
//  Benji
//
//  Created by Benji Dodgson on 2/3/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient
import Parse
import TMROFutures
import ReactiveSwift

extension TCHChannel: Diffable, ManageableCellItem {

    var id: String {
        return self.sid!
    }
    
    var backgroundColor: Color {
        return .blue
    }

    func diffIdentifier() -> NSObjectProtocol {
        return String(optional: self.sid) as NSObjectProtocol
    }

    func joinIfNeeded() -> Future<TCHChannel> {
        let promise = Promise<TCHChannel>(value: self)
        return promise.joinIfNeeded().then(with: { (channel) in
            return Promise<TCHChannel>(value: channel)
        }).then(with: { (channel) in
            return Promise<TCHChannel>(value: channel)
        })
    }

    func getNonMeMembers() -> Future<[TCHMember]> {

        let promise = Promise<[TCHMember]>()
        if let members = self.members {
            members.members { (result, paginator) in
                if let error = result.error {
                    promise.reject(with: error)
                } else if let pag = paginator {
                    var nonMeMembers: [TCHMember] = []
                    pag.items().forEach { (member) in
                        if member.identity != User.current()?.objectId {
                            nonMeMembers.append(member)
                        }
                    }
                    promise.resolve(with: nonMeMembers)
                } else {
                    promise.reject(with: ClientError.generic)
                }
            }
        }

        return promise.withResultToast()
    }

    func getAuthorAsUser() -> Future<User> {
        let promise = Promise<TCHChannel>(value: self)
        return promise.getAuthorAsUser()
    }

    func getMembersAsUsers() -> Future<[User]> {
        let promise = Promise<TCHChannel>(value: self)
        return promise.getUsers()
    }

    var channelDescription: String {
        guard let attributes = self.attributes(),
            let text = attributes[ChannelKey.description.rawValue] as? String else { return String() }
        return text
    }

    func getUnconsumedCount() -> SignalProducer<FeedType, Error> {
        var totalUnread: Int = 0

        return SignalProducer { [weak self] observer, lifetime in
            guard let `self` = self else { return }

            if let messagesObject = self.messages {
                self.getMessagesCount { (result, count) in
                    if result.isSuccessful() {
                        messagesObject.getLastWithCount(count) { (messageResult, messages) in

                            if messageResult.isSuccessful(), let msgs = messages {
                                msgs.forEach { (message) in
                                    if !message.isFromCurrentUser, !message.isConsumed, message.canBeConsumed {
                                        totalUnread += 1
                                    }
                                }
                                observer.send(value: .unreadMessages(self, totalUnread))
                                observer.sendCompleted()
                            } else {
                                observer.send(error: ClientError.generic)
                            }
                        }
                    } else {
                        observer.send(error: ClientError.generic)
                    }
                }
            } else {
                observer.send(error: ClientError.generic)
            }
        }
    }
}

extension Future where Value == TCHChannel {

    func joinIfNeeded() -> Future<TCHChannel> {

        return self.then(with: { (channel) in

            // There's no need to join the channel if the current user is already a member
            guard let id = PFUser.current()?.objectId, channel.member(withIdentity: id) == nil else {
                return Promise<TCHChannel>(value: channel)
            }

            let promise = Promise<TCHChannel>()
            channel.join(completion: { (result) in
                if let error = result.error {
                    promise.reject(with: error)
                } else {
                    self.sendJoinedMessage()
                        .observe { (messageResult) in
                           promise.resolve(with: channel)
                    }
                }
            })

            return promise.withResultToast()
        })
    }

    func sendJoinedMessage() -> Future<TCHChannel> {
        return self.then { (channel) in
            let promise = Promise<TCHChannel>()

            let message = "joined: \(String(optional: channel.friendlyName))"

            ChannelManager.shared.sendMessage(to: channel, with: message, context: .status)
                .observe { (result) in
                    switch result {
                    case .success(_):
                        return promise.resolve(with: channel)
                    case .failure(_):
                        return promise.reject(with: ClientError.generic)
                    }
            }

            return promise
        }
    }

    func invite(user: User) -> Future<TCHChannel> {

        return self.then(with: { (channel) in

            let promise = Promise<TCHChannel>()
            let identity = String(optional: user.objectId)
            channel.members!.invite(byIdentity: identity) { (result) in
                if let error = result.error {
                    promise.reject(with: error)
                } else {
                    if let handle = user.handle {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "h:mm a"

                        let monthDayFormatter = DateFormatter()
                        monthDayFormatter.dateFormat = "MMMM d"

                        let message = "Invite sent at \(formatter.string(from: Date())) on \(monthDayFormatter.string(from: Date())) to: [\(handle)](\(identity))"

                        ChannelManager.shared.sendMessage(to: channel, with: message, context: .status)
                            .observe { (result) in
                                switch result {
                                case .success(_):
                                    return promise.resolve(with: channel)
                                case .failure(_):
                                    return promise.reject(with: ClientError.generic)
                                }
                        }
                    } else {
                        promise.resolve(with: channel)
                    }
                }
            }

            return promise.withResultToast()
        })
    }

    func getAuthorAsUser() -> Future<User> {
        return self.then(with: { (channel) in
            let promise = Promise<User>()
            if let authorID = channel.createdBy {
                User.localThenNetworkQuery(for: authorID)
                    .observe { (result) in
                        switch result {
                        case .success(let user):
                            promise.resolve(with: user)
                        case .failure(let error):
                            promise.reject(with: error)
                        }
                }
            } else {
                promise.reject(with: ClientError.generic)
            }

            return promise
        })
    }

    func getUsers() -> Future<[User]> {
        return self.then { (channel) in
            let promise = Promise<[User]>()
            if let members = channel.members {
                members.members { (result, paginator) in
                    if result.isSuccessful(), let pag = paginator {
                        var identifiers: [String] = []
                        pag.items().forEach { (member) in
                            if let identifier = member.identity {
                                identifiers.append(identifier)
                            }
                        }

                        User.localThenNetworkArrayQuery(where: identifiers,
                                                        isEqual: true, 
                                                        container: .channel(identifier: channel.sid!))
                            .observe { (result) in
                                switch result {
                                case .success(let users):
                                    promise.resolve(with: users)
                                case .failure(let error):
                                    promise.reject(with: error)
                                }
                        }
                    } else {
                        promise.reject(with: ClientError.generic)
                    }
                }
            }

            return promise
        }
    }
}

extension TCHChannel: ImageDisplayable {

    var user: User? {
        return nil
    }

    var image: UIImage? {
        return UIImage(systemName: "text.bubble.fill")
    }
    
    var userObjectID: String? {
        return self.createdBy
    }

    var context: MessageContext? {
        guard let attributes = self.attributes(),
            let contextString = attributes["context"] as? String,
            let context = MessageContext(rawValue: contextString) else { return nil }
        return context
    }
}
