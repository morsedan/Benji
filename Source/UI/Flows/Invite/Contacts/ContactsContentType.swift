//
//  InviteContentType.swift
//  Benji
//
//  Created by Benji Dodgson on 2/1/20.
//  Copyright © 2020 Benjamin Dodgson. All rights reserved.
//

import Foundation

enum ContactsContentType: Switchable {

    case contacts(ContactsViewController)

    var viewController: UIViewController & Sizeable {
        switch self {
        case .contacts(let vc):
            return vc
        }
    }

    var shouldShowBackButton: Bool {
        return false
    }
}

