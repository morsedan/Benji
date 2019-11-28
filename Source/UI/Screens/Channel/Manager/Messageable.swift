//
//  Messageable.swift
//  Benji
//
//  Created by Benji Dodgson on 11/9/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TMROLocalization

enum MessageStatus: String {
    case sent //Message was sent
    case delivered //Message was successfully delivered but not consumed
    case read //Message was consumed
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
    var status: MessageStatus { get }
    var avatar: Avatar { get }
    var id: String { get }
    func updateTo(status: MessageStatus) -> Future<Void>
}

func ==(lhs: Messageable, rhs: Messageable) -> Bool {
    guard type(of: lhs) == type(of: rhs) else { return false }
    return lhs.createdAt == rhs.createdAt
        && lhs.text == rhs.text
        && lhs.authorID == rhs.authorID
        && lhs.messageIndex == rhs.messageIndex
        && lhs.id == rhs.id 
}
