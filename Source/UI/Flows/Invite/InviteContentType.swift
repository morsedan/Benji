//
//  InviteContentType.swift
//  Benji
//
//  Created by Benji Dodgson on 2/1/20.
//  Copyright © 2020 Benjamin Dodgson. All rights reserved.
//

import Foundation

enum InviteContenType: Switchable {
    case contacts(ContactsViewController)
    case composer(ComposerViewController)

    var viewController: UIViewController & Sizeable {
        switch self {
        case .contacts(let vc):
            return vc
        case .composer(let vc):
            return vc
        }
    }

    var shouldShowBackButton: Bool {
        return false
    }
}

