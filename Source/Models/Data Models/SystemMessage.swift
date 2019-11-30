//
//  SystemMessage.swift
//  Benji
//
//  Created by Benji Dodgson on 6/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TMROLocalization

class SystemMessage: Messageable {

    var createdAt: Date
    var text: Localized
    var authorID: String
    var messageIndex: NSNumber?
    var attributes: [String : Any]?
    var avatar: Avatar
    var context: MessageContext
    var isFromCurrentUser: Bool
    var status: MessageStatus
    var id: String
    var updateId: String? {
        return self.attributes?["updateId"] as? String
    }
    var hasBeenConsumedBy: [String] {
        return self.attributes?["consumers"] as? [String] ?? []
    }

    init(avatar: Avatar,
         context: MessageContext,
         text: Localized,
         isFromCurrentUser: Bool,
         createdAt: Date,
         authorId: String,
         messageIndex: NSNumber?,
         status: MessageStatus,
         id: String,
         attributes: [String: Any]?) {

        self.avatar = avatar
        self.context = context
        self.isFromCurrentUser = isFromCurrentUser
        self.text = text
        self.createdAt = createdAt
        self.authorID = authorId
        self.messageIndex = messageIndex
        self.status = status
        self.id = id
        self.attributes = attributes
    }

    // Used for updating the read state of messages
    convenience init(with message: Messageable) {

        self.init(avatar: message.avatar,
                  context: message.context,
                  text: message.text,
                  isFromCurrentUser: message.isFromCurrentUser,
                  createdAt: message.createdAt,
                  authorId: message.authorID,
                  messageIndex: message.messageIndex,
                  status: message.status,
                  id: message.id,
                  attributes: message.attributes)
    }

    func udpateConsumers(with consumer: Avatar) {
        guard let identity = consumer.userObjectID else { return }
        var consumers = self.hasBeenConsumedBy
        consumers.append(identity)
    }
}
