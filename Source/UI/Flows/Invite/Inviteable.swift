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

extension Inviteable: Avatar {

    var givenName: String {
        switch self {
        case .contact(let contact):
            return contact.givenName
        case .user(let user):
            return user.givenName
        }
    }

    var familyName: String {
        switch self {
        case .contact(let contact):
            return contact.familyName
        case .user(let user):
            return user.familyName
        }
    }

    var userObjectID: String? {
        switch self {
        case .contact(_):
            return nil
        case .user(let user):
            return user.objectId!
        }
    }

    var image: UIImage? {
        switch self {
        case .contact(let contact):
            return contact.image
        case .user(let user):
            return user.image
        }
    }

    var phoneNumber: String? {
        switch self {
        case .contact(let contact):
            return contact.primaryPhoneNumber
        case .user(let user):
            return user.phoneNumber
        }
    }
}
