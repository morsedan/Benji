//
//  ViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 12/25/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, Dismissable {

    var didDismiss: (() -> Void)?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        once(caller: self, token: String(describing: self)) {
            self.viewIsReadyForLayout()
        }
    }

    func viewIsReadyForLayout() {}

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if self.isBeingClosed {
            self.didDismiss?()
        }
    }
}

