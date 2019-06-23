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

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if self.isBeingClosed {
            self.viewWasDismissed()
            self.didDismiss?()
        }
    }

    func viewWasDismissed() { }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

