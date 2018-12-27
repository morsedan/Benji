//
//  ViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 12/25/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, Dismissable {

    @IBOutlet weak var regular: UILabel!
    @IBOutlet weak var demiBold: UILabel!
    @IBOutlet weak var heavy: UILabel!
    @IBOutlet weak var medium: UILabel!
    @IBOutlet weak var ultraLight: UILabel!

    var didDismiss: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.regular.font = UIFont(name: Theme.regular, size: 20)
        self.demiBold.font = UIFont(name: Theme.demiBold, size: 20)
        self.heavy.font = UIFont(name: Theme.heavy, size: 20)
        self.medium.font = UIFont(name: Theme.medium, size: 20)
        self.ultraLight.font = UIFont(name: Theme.ultraLight, size: 20)
    }

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

