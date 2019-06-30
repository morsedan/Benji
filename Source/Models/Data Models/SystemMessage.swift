//
//  SystemMessage.swift
//  Benji
//
//  Created by Benji Dodgson on 6/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

struct SystemMessage: Diffable, Hashable {

    var avatar: Avatar
    var context: MessageContext
    var body: String
    var id: String

    func diffIdentifier() -> NSObjectProtocol {
        return self.id as NSObjectProtocol
    }

    static func == (lhs: SystemMessage, rhs: SystemMessage) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
