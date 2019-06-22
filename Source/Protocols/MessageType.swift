//
//  MessageType.swift
//  Benji
//
//  Created by Benji Dodgson on 6/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

protocol MessageType {

    /// The sender of the message.
    var sender: SenderType { get }

    /// The unique identifier for the message.
    var messageId: String { get }

    /// The date the message was sent.
    var sentDate: Date { get }

    /// The kind of message and its underlying kind.
    var kind: MessageKind { get }
}
