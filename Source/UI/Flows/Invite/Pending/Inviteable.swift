//
//  Inviteable.swift
//  Benji
//
//  Created by Benji Dodgson on 2/8/20.
//  Copyright © 2020 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Contacts

enum Inviteable: ManageableCellItem {
    case contact(CNContact)
    case user(User)

    var id: String {
        switch self {
        case .contact(let contact):
            return contact.identifier
        case .user(let user):
            return user.objectId!
        }
    }
}
