//
//  ContactsScrolledModalController.swift
//  Benji
//
//  Created by Benji Dodgson on 6/30/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ContactsScrolledModalController: ScrolledModalController {

    let contactsVC: ContactsViewController

    init() {
        let vc = ContactsViewController()
        self.contactsVC = vc
        super.init(presentable: vc)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func scrolledModalContainerViewFinishedAnimating(_ container: ScrolledModalContainerView,
                                                              withProgress progress: Float) {
        super.scrolledModalContainerViewFinishedAnimating(container, withProgress: progress)

        guard progress == 1 else { return }

        once(caller: self, token: "getAuthorizationStatus") {
            self.contactsVC.getAuthorizationStatus()
        }
    }
}
