//
//  InviteContentType.swift
//  Benji
//
//  Created by Benji Dodgson on 2/1/20.
//  Copyright © 2020 Benjamin Dodgson. All rights reserved.
//

import Foundation

enum InvitesContentType: Switchable {

    case contacts(ContactsViewController)
    case pending(PendingCollectionViewController)

    var viewController: UIViewController & Sizeable {
        switch self {
        case .contacts(let vc):
            return vc
        case .pending(let vc):
            return vc
        }
    }

    var shouldShowBackButton: Bool {
        switch self {
        case .contacts(_):
            return true
        case .pending(_):
            return false
        }
    }
}

