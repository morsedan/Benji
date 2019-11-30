//
//  Messageable.swift
//  Benji
//
//  Created by Benji Dodgson on 11/9/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TMROLocalization
import TwilioChatClient

enum MessageStatus: String {
    case sent //Message was sent as a system message
    case delivered //Message was successfully delivered by Twilio
    case unknown
    case error
}

protocol Messageable: class {

    var createdAt: Date { get }
    var text: Localized { get }
    var isFromCurrentUser: Bool { get }
    var authorID: String { get }
    var messageIndex: NSNumber? { get }
    var attributes: [String: Any]? { get }
    var avatar: Avatar { get }
    var id: String { get }
    var updateId: String? { get }
    var status: MessageStatus { get }
    var context: MessageContext { get }
    var isConsumed: Bool { get }
    var hasBeenConsumedBy: [String] { get }
    func udpateConsumers(with consumer: Avatar)
    func appendAttributes(with attributes: [String: Any]) -> Future<Void>
}

func ==(lhs: Messageable, rhs: Messageable) -> Bool {
    guard type(of: lhs) == type(of: rhs) else { return false }
    return lhs.createdAt == rhs.createdAt
        && lhs.text == rhs.text
        && lhs.authorID == rhs.authorID
        && lhs.messageIndex == rhs.messageIndex
        && lhs.id == rhs.id
}

extension Messageable {

    var updateId: String? {
        return nil 
    }

    var isConsumed: Bool {
        return self.hasBeenConsumedBy.count > 0 
    }

    func appendAttributes(with attributes: [String: Any]) -> Future<Void>  {
        return Promise<Void>()
    }
}
