//
//  InviteViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 2/1/20.
//  Copyright © 2020 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TMROLocalization
import Contacts

typealias InviteViewControllerDelegates = ContactsViewControllerDelegate & InviteViewControllerDelegate

protocol InviteViewControllerDelegate: class {
    func inviteView(_ controller: InviteViewController, didSelect contacts: [CNContact])
}

class InviteViewController: SwitchableContentViewController<InviteContenType> {

    lazy var contactsVC = ContactsViewController(with: self.delegate)
    unowned let delegate: InviteViewControllerDelegates
    private let button = Button()

    var selectedContacts: [CNContact] {
        return self.contactsVC.collectionViewManager.selectedItems
    }

    init(with delegate: InviteViewControllerDelegates) {
        self.delegate = delegate
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initializeViews() {
        super.initializeViews()

        self.button.set(style: .normal(color: .purple, text: "Send Invites"))
        self.view.addSubview(self.button)
        self.button.didSelect = { [unowned self] in
            self.contactsVC.getAuthorizationStatus()
        }
        
        self.view.set(backgroundColor: .background2)

        self.contactsVC.collectionViewManager.onSelectedItem.signal.observeValues { [unowned self] (_) in
            /// update the desctipion
            self.updateLabels()
            self.updateButton()
        }

        self.contactsVC.getAuthorizationStatus()
    }

    override func getTitle() -> Localized {
        return "Invites"
    }

    override func getDescription() -> Localized {
        switch self.currentContent.value {
        case .contacts(_):
            if self.selectedContacts.count > 1 {
                return "Tap the button below to send your invites."
            } else {
                return "Select the people you want to invite."
            }
        }
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

    private func updateButton() {
        let count = self.contactsVC.collectionViewManager.selectedItems.count
        let buttonText: LocalizedString
        if count > 1 {
            buttonText = LocalizedString(id: "",
                                         arguments: [String(count)],
                                         default: "Send @() invites")
        } else {
            buttonText = LocalizedString(id: "", default: "Send invite")
        }

        self.button.set(style: .normal(color: .purple, text: buttonText))
    }
}
