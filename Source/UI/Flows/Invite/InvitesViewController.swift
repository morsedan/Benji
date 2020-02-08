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

typealias InvitesViewControllerDelegates = InvitesViewControllerDelegate & ContactsViewControllerDelegate

protocol InvitesViewControllerDelegate: class {
    func invitesView(_ controller: InvitesViewController, didSelect contacts: [CNContact])
}

class InvitesViewController: SwitchableContentViewController<InvitesContentType> {

    lazy var contactsVC = ContactsViewController(with: self.delegate)
    lazy var pendingVC = PendingCollectionViewController()

    unowned let delegate: InvitesViewControllerDelegates
    private let button = Button()
    var buttonOffset: CGFloat?

    var selectedContacts: [CNContact] {
        return self.contactsVC.collectionViewManager.selectedItems
    }

    init(with delegate: InvitesViewControllerDelegates) {
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
            self.delegate.invitesView(self, didSelect: self.selectedContacts)
        }
        
        self.view.set(backgroundColor: .background2)

        self.currentContent.signal.observeValues { (_) in
            self.updateButton()
        }

        self.contactsVC.collectionViewManager.onSelectedItem.signal.observeValues { [unowned self] (_) in
            /// update the desctipion
            self.updateLabels()
            self.updateButton()
        }

        self.contactsVC.getAuthorizationStatus()
    }

    func reset() {
        switch self.currentContent.value {
        case .contacts(_):
            self.buttonOffset = nil
            self.animateButton(with: self.view.height + 100)
            self.contactsVC.collectionViewManager.reset()
            self.contactsVC.getContacts()
        case .pending(_):
            break
        }
    }

    override func getTitle() -> Localized {
        switch self.currentContent.value {
        case .contacts(_):
            return "Send Invites"
        case .pending(_):
            return "Pending Invites"
        }
    }

    override func getDescription() -> Localized {
        switch self.currentContent.value {
        case .contacts(_):
            return "Select the people you want to invite."
        case .pending(let vc):
            let count = String(vc.collectionViewManager.items.value.count)
            let description = LocalizedString(id: "",
                                              arguments: [count],
                                              default: "You have @(count) pending invites.")
            return description
        }
    }

    override func getInitialContent() -> InvitesContentType {
        return .pending(self.pendingVC)
    }

    override func willUpdateContent() {
        self.view.bringSubviewToFront(self.button)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.button.size(with: self.view.width)
        self.button.centerOnX()
        self.button.bottom = self.buttonOffset ?? self.view.height + 100
    }

    private func updateButton() {
        switch self.currentContent.value {
        case .contacts(_):
            self.updateButtonForContacts()
        case .pending(_):
            self.updateButtonForPending()
        }
    }

    private func updateButtonForPending() {
        self.button.set(style: .normal(color: .purple, text: "Choose Others"))
        let offset = self.view.height - self.view.safeAreaInsets.bottom
        self.animateButton(with: offset)
    }

    private func updateButtonForContacts() {
        let buttonText: LocalizedString
        if self.selectedContacts.count > 1 {
            buttonText = LocalizedString(id: "",
                                         arguments: [String(self.selectedContacts.count)],
                                         default: "SEND @(count) INVITES")
        } else {
            buttonText = LocalizedString(id: "", default: "SEND INVITE")
        }

        self.button.set(style: .normal(color: .purple, text: buttonText))

        var newOffset: CGFloat
        if self.selectedContacts.count >= 1 {
            newOffset = self.view.height - self.view.safeAreaInsets.bottom
        } else {
            newOffset = self.view.height + 100
        }

        self.animateButton(with: newOffset)
    }

    private func animateButton(with newOffset: CGFloat) {
        guard self.buttonOffset != newOffset else { return }

        self.buttonOffset = newOffset
        UIView.animate(withDuration: Theme.animationDuration,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
                        self.view.layoutNow()
        }) { (completed) in }
    }
}
