//
//  InviteCoordinator.swift
//  Benji
//
//  Created by Benji Dodgson on 2/1/20.
//  Copyright © 2020 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Contacts

class InviteCoordinator: PresentableCoordinator<Void> {

    lazy var inviteVC = InviteViewController(with: self)

    override func toPresentable() -> DismissableVC {
        return self.inviteVC
    }
}

extension InviteCoordinator: ContactsViewControllerDelegate {

    func contactsView(_ controller: ContactsViewController, didGetAuthorization status: CNAuthorizationStatus) {
        switch status {
        case .notDetermined, .restricted, .denied:
            runMain {
                self.askForAuthorization(status: status, source: controller)
            }
        case .authorized:
            controller.getContacts()
        @unknown default:
            runMain {
                self.askForAuthorization(status: status, source: controller)
            }
        }
    }

    private func askForAuthorization(status: CNAuthorizationStatus, source: ContactsViewController) {

        let contactModal = ContactAuthorizationAlertController(status: status)
        contactModal.onAuthorization = { (result) in
            switch result {
            case .denied:
                contactModal.dismiss(animated: true, completion: nil)
            case .authorized:
                contactModal.dismiss(animated: true) {
                    source.getContacts()
                }
            }
        }

        self.router.present(contactModal, source: source)
    }
}
