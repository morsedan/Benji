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

    private func fetchAllData() {
        UserNotificationManager.shared.requestAuthorization()

        User.anonymousLogin()
            .observe { (result) in
                switch result {
                case .success(_):
                    self.runHomeFlow()
                case .failure(let error):
                    print(error)
                }
        }
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
        let controller = LoginEndingViewController(with: self)
        self.router.push(controller)
    }
}

extension LoginCoordinator: LoginEndingViewControllerDelegate {
    func loginEndingViewControllerDidComplete(_ controller: LoginEndingViewController) {
        self.finishFlow(with: ())
    }
}
