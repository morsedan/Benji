//
//  LoginFlowViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 8/10/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import ReactiveSwift
import PhoneNumberKit
import Parse
import UserNotifications

protocol LoginFlowable: class {
    var didComplete: (() -> Void)? { get set }
    var didClose: (() -> Void)? { get set }
}

enum LoginStep {
    case phone
    case verifyCode(PhoneNumber)
    case name
    case profilePicture
    case last
}

typealias LoginFlowableViewController = UIViewController & LoginFlowable

enum LoginFlowResult {
    case loggedIn
    case cancelled
}

protocol LoginFlowViewControllerDelegate: class {
    func loginFlowViewController(_ controller: LoginFlowViewController,
                                 finishedWith result: LoginFlowResult)
}

class LoginFlowViewController: FullScreenViewController {

    private var userExists: Bool

    // A view that covers up the other view controllers when loading
    var loadingView = LoadingView()

    weak var delegate: LoginFlowViewControllerDelegate?

    init(userExists: Bool) {
        self.userExists = userExists
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    required init?(withObject object: DeepLinkable) {
        fatalError("init(withObject:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.loadingView)

        self.handle(step: .phone)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.loadingView.size = CGSize(width: self.view.width, height: self.view.height)
        self.loadingView.bottom = self.view.height
        self.loadingView.centerOnX()
    }

    func handle(step: LoginStep) {
        switch step {
        case .phone:
            self.configurePhone()
        case .verifyCode(let phoneNumber):
            self.configureVerifyCode(with: phoneNumber)
        case .name:
            self.configureNameController()
        case .profilePicture:
            self.configureProfilePictureController()
        case .last:
            self.configureLast()
        }
    }

    private func configurePhone() {
        guard let current = PFUser.current(), current.phoneNumber == nil else {
            self.handle(step: .name)
            return
        }

        let vc = LoginPhoneViewController()
        vc.didComplete = { [unowned self] phone in
            if let phoneNumber = phone {
                self.handle(step: .verifyCode(phoneNumber))
            }
        }
        //self.add(controller: vc)
        //self.moveForward()
        delay(0.5) {
            vc.textField.becomeFirstResponder()
        }
    }

    private func configureVerifyCode(with phoneNumber: PhoneNumber) {

        let vc = LoginCodeViewController(phoneNumber: phoneNumber)
        vc.didVerifyUser = { [weak self] user in
            guard let `self` = self else { return }
            //show the last vc or the loading screen if there isnt one
            self.handle(step: .name)
        }
        //self.add(controller: vc)
        //self.moveForward()
        delay(0.5) {
            vc.textField.becomeFirstResponder()
        }
    }

    private func configureNameController() {

        let vc = LoginNameViewController()
        vc.didAddName = { [weak self] in
            guard let `self` = self else { return }
            vc.textField.resignFirstResponder()
            self.handle(step: .profilePicture)
        }
        //self.add(controller: vc)
        //self.moveForward()
        delay(0.5) {
            vc.textField.becomeFirstResponder()
        }
    }

    func configureProfilePictureController() {

        let vc = LoginProfilePhotoViewController()
        vc.didSavePhoto = { [weak self] in
            guard let `self` = self else { return }
            //show the last vc or the loading screen if there isnt one
            self.handle(step: .last)
        }
        //self.add(controller: vc)
        //self.moveForward()
    }

    private func configureLast() {

        let controller = LoginEndingViewController()
        controller.didComplete = {
            self.fetchAllData()
        }
        //self.add(controller: controller)
        //self.moveForward()
    }

    private func fetchAllData() {
        guard let _ = PFUser.current() else { return }

    
        UserNotificationManager.shared.requestAuthorization()

        PFAnonymousUtils.logIn { (user, error) in
            if error != nil || user == nil {
                print("Anonymous login failed.")
            } else {
                self.finishFlow(with: .loggedIn)
            }
        }
    }

    func finishFlow(with result: LoginFlowResult) {
        self.delegate?.loginFlowViewController(self, finishedWith: result)
    }
}
