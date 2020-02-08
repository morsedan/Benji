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

typealias ContactSelectionViewControllerDelegates = ContactSelectionViewControllerDelegate & ContactsViewControllerDelegate

protocol ContactSelectionViewControllerDelegate: class {
    func contactSelectionView(_ controller: InvitesViewController, didSelect contacts: [CNContact])
}

class InvitesViewController: SwitchableContentViewController<ContactsContentType> {

    lazy var contactsVC = ContactsViewController(with: self.delegate)

    unowned let delegate: ContactSelectionViewControllerDelegates
    private let button = Button()
    var buttonOffset: CGFloat?

    var selectedContacts: [CNContact] {
        return self.contactsVC.collectionViewManager.selectedItems
    }

    init(with delegate: ContactSelectionViewControllerDelegates) {
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
            self.delegate.contactSelectionView(self, didSelect: self.selectedContacts)
        }
        
        self.view.set(backgroundColor: .background2)

        self.contactsVC.collectionViewManager.onSelectedItem.signal.observeValues { [unowned self] (_) in
            /// update the desctipion
            self.updateLabels()
            self.updateButton()
        }

        self.contactsVC.getAuthorizationStatus()
    }

    func reset() {
        self.buttonOffset = nil
        self.animateButton()
        self.contactsVC.collectionViewManager.reset()
        self.contactsVC.getContacts()
    }

    override func getTitle() -> Localized {
        return "Invites"
    }

    override func getDescription() -> Localized {
        return "Select the people you want to invite."
    }

    override func getInitialContent() -> ContactsContentType {
        return .contacts(self.contactsVC)
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
        let buttonText: LocalizedString
        if self.selectedContacts.count > 1 {
            buttonText = LocalizedString(id: "",
                                         arguments: [String(self.selectedContacts.count)],
                                         default: "SEND @(count) INVITES")
        } else {
            buttonText = LocalizedString(id: "", default: "SEND INVITE")
        }

        self.button.set(style: .normal(color: .purple, text: buttonText))
        self.animateButton()
    }

    private func animateButton() {
        var newOffset: CGFloat
        if self.selectedContacts.count >= 1 {
            newOffset = self.view.height - self.view.safeAreaInsets.bottom
        } else {
            newOffset = self.view.height + 100
        }

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
