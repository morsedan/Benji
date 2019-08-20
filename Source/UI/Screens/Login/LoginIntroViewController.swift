//
//  LoginIntroViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 8/19/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class LoginIntroViewController: LoginFlowableViewController {
    var didComplete: (() -> Void)? 
    var didClose: (() -> Void)?

    let displayLabel = Display2Label()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.set(backgroundColor: .background3)
        self.view.addSubview(self.displayLabel)
        self.displayLabel.set(text: "Welcome! 👋\n ~Benji", alignment: .center)

        delay(3.0) {
            self.didComplete?()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.displayLabel.setSize(withWidth: self.view.width * 0.8)
        self.displayLabel.centerOnXAndY()
    }
}
