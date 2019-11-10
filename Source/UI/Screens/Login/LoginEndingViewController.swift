//
//  LoginEndingViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 8/19/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse
import TMROLocalization

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

        guard let current = User.current() else { return }

        let text = LocalizedString(id: "",
                                   arguments: [current.givenName],
                                   default: "@1, I made this for you.\n\n ~Benji")
        self.displayLabel.set(text: text,
                              alignment: .center,
                              stringCasing: .capitalized)

        self.fetchAllData()
            .observe { (result) in
                switch result {
                case .success:
                    delay(3.0) {
                        self.delegate.loginEndingViewControllerDidComplete(self)
                    }
                case .failure(let error):
                    print(error)
                }
        }
    }

    private func fetchAllData() -> Future<Void> {
        let promise = Promise<Void>()
        User.anonymousLogin()
            .observe { (result) in
                switch result {
                case .success(let user):
                    Reservation.create()
                        .observe { (result) in
                            switch result {
                            case .success(let reservation):
                                user.reservation = reservation
                                user.createHandle()
                                user.saveObject()
                                    .observe { (userResult) in
                                        switch userResult {
                                        case .success(_):
                                            promise.resolve(with: ())
                                        case .failure(let error):
                                            promise.reject(with: error)
                                        }
                                }
                            case .failure(let error):
                                promise.reject(with: error)
                            }
                    }
                case .failure(let error):
                    promise.reject(with: error)
                }
        }

        return promise
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.displayLabel.setSize(withWidth: self.view.proportionalWidth)
        self.displayLabel.centerY = self.view.centerY * 0.8
        self.displayLabel.centerOnX()
    }
}
