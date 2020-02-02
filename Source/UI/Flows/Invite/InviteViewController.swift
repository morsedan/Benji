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
    private let button = Button()

    init(with delegate: ContactsViewControllerDelegate) {
        self.delegate = delegate
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initializeViews() {
        super.initializeViews()

        self.button.set(style: .normal(color: .purple, text: "GET CONTACTS"))
        self.view.addSubview(self.button)
        self.button.didSelect = { [unowned self] in
            self.contactsVC.getAuthorizationStatus()
        }
        
        self.view.set(backgroundColor: .background2)
    }

    override func getTitle() -> Localized {
        return "Contacts"
    }

    override func getDescription() -> Localized {
        return "Some description"
    }

    override func getInitialContent() -> InviteContenType {
        return .contacts(self.contactsVC)
    }

    override func willUpdateContent() {
        self.view.bringSubviewToFront(self.button)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.button.size(with: self.view.width)
        self.button.centerOnX()
        self.button.bottom = self.view.height - self.view.safeAreaInsets.bottom - 10
    }
}
