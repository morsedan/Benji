//
//  LoginCoordinator.swift
//  Benji
//
//  Created by Benji Dodgson on 8/10/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import PhoneNumberKit
import Parse

class LoginCoordinator: PresentableCoordinator<Void> {

    lazy var loginPhoneVC = LoginPhoneViewController(with: self)

    override func toPresentable() -> DismissableVC {
        return self.loginPhoneVC
    }

    private func runHomeFlow() {
        let coordinator = HomeCoordinator(router: self.router, deepLink: self.deepLink)
        self.router.setRootModule(coordinator, animated: true)
        self.addChildAndStart(coordinator, finishedHandler: { _ in
            // If the home coordinator ever finishes, put handling logic here.
        })
    }
}

extension LoginCoordinator: LoginPhoneViewControllerDelegate {
    func loginPhoneView(_ controller: LoginPhoneViewController, didCompleteWith phone: PhoneNumber) {
        let controller = LoginCodeViewController(with: self, phoneNumber: phone)
        self.router.push(controller)
    }
}

extension LoginCoordinator: LoginCodeViewControllerDelegate {
    func loginCodeView(_ controller: LoginCodeViewController, didVerify user: PFUser) {
        let controller = LoginNameViewController(with: self)
        self.router.push(controller)
    }
}

extension LoginCoordinator: LoginNameViewControllerDelegate {
    func loginNameViewControllerDidComplete(_ controller: LoginNameViewController) {
        let controller = LoginProfilePhotoViewController(with: self)
        self.router.push(controller)
    }
}

extension LoginCoordinator: LoginProfilePhotoViewControllerDelegate {
    func loginProfilePhotoViewControllerDidUpdatePhoto(_ controller: LoginProfilePhotoViewController) {
        self.fetchAllData()
            .observe { (result) in
                switch result {
                case .success:
                    self.finishFlow(with: ())
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
}
