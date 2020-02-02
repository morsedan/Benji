//
//  InviteCoordinator.swift
//  Benji
//
//  Created by Benji Dodgson on 2/1/20.
//  Copyright © 2020 Benjamin Dodgson. All rights reserved.
//

import Foundation

class InviteCoordinator: PresentableCoordinator<Void> {

    lazy var contactsVC = ContactsViewController()

    override func toPresentable() -> DismissableVC {
        return self.contactsVC
    }
}
