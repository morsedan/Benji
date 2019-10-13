//
//  LoginEndingViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 8/19/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse

protocol LoginEndingViewControllerDelegate: class {
    func loginEndingViewControllerDidComplete(_ controller: LoginEndingViewController)
}

class LoginEndingViewController: ViewController {

    let displayLabel = RegularSemiBoldLabel()

    unowned let delegate: LoginEndingViewControllerDelegate

    init(with delegate: LoginEndingViewControllerDelegate) {
        self.delegate = delegate
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initializeViews() {
        super.initializeViews()

        self.view.set(backgroundColor: .background1)
        self.view.addSubview(self.displayLabel)

        guard let current = PFUser.current() else { return }

        let text = LocalizedString(id: "",
                                   arguments: [current.firstName],
                                   default: "@1, I made this for you.\n\n ~Benji")
        self.displayLabel.set(text: text,
                              alignment: .center,
                              stringCasing: .capitalized)

        self.fetchAllData()
    }

    private func fetchAllData() {
        PFAnonymousUtils.logIn { (user, error) in
            if error != nil || user == nil {
                print("Anonymous login failed.")
            } else {
                delay(3.0) {
                    self.delegate.loginEndingViewControllerDidComplete(self)
                }
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.displayLabel.setSize(withWidth: self.view.proportionalWidth)
        self.displayLabel.centerY = self.view.centerY * 0.8
        self.displayLabel.centerOnX()
    }
}
