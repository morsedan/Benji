//
//  InviteViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 2/1/20.
//  Copyright © 2020 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TMROLocalization

class InviteViewController: SwitchableContentViewController<InviteContenType> {

    lazy var contactsVC = ContactsViewController(with: self.delegate)
    unowned let delegate: ContactsViewControllerDelegate

    init(with delegate: ContactsViewControllerDelegate) {
        self.delegate = delegate
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func getTitle() -> Localized {
        return "Contacts"
    }

    override func getDescription() -> Localized {
        return "Some description"
    }
}
