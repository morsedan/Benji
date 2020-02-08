//
//  MessageComposerViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 2/2/20.
//  Copyright © 2020 Benjamin Dodgson. All rights reserved.
//

import Foundation
import MessageUI

class MessageComposerViewController: MFMessageComposeViewController, Presentable, Dismissable {

    func toPresentable() -> DismissableVC {
        return self
    }

    var isFinished: Bool { return true }

    var dismissHandlers: [() -> Void] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.modalPresentationStyle = .automatic       
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if self.isBeingClosed {
            self.dismissHandlers.forEach { (dismissHandler) in
                dismissHandler()
            }
        }
    }
}
