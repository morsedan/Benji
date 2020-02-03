//
//  InviteModalViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 2/2/20.
//  Copyright © 2020 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Contacts

protocol InviteModalViewControllerDelegate: class {
    func inviteModalViewControllerDidFinish(_ controller: InviteModalViewController)
}

class InviteModalViewController: ViewController {

    private var contacts: [CNContact]
    unowned let delegate: InviteModalViewControllerDelegate

    init(with contacts: [CNContact], delegate: InviteModalViewControllerDelegate) {
        self.contacts = contacts
        self.delegate = delegate
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initializeViews() {
        super.initializeViews()

        
    }
}
