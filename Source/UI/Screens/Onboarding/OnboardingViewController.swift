//
//  OnboardingViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 1/14/20.
//  Copyright © 2020 Benjamin Dodgson. All rights reserved.
//

import Foundation
import PhoneNumberKit
import Parse
import ReactiveSwift

protocol OnboardingViewControllerDelegate: class {
    func onboardingView(_ controller: OnboardingViewController, didVerify user: PFUser)
}

class OnboardingViewController: SwitchableContentViewController<OnboardingContent> {

    lazy var reservationVC = ReservationViewController()
    lazy var phoneVC = LoginPhoneViewController(with: self)
    lazy var codeVC = LoginCodeViewController(with: self)
    lazy var nameVC = LoginNameViewController(with: self)
    lazy var photoVC = LoginProfilePhotoViewController(with: self)
    
    unowned let delegate: OnboardingViewControllerDelegate

    init(with delegate: OnboardingViewControllerDelegate) {
        self.delegate = delegate
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initializeViews() {
        super.initializeViews()

        self.reservationVC.onDidComplete = { [unowned self] result in
            switch result {
            case .success:
                self.currentContent.value = .phone(self.phoneVC)
            case .failure(let error):
                print(error)
            }
        }

        self.phoneVC.onDidComplete = { [unowned self] result in
            switch result {
            case .success:
                self.currentContent.value = .code(self.codeVC)
            case .failure(let error):
                print(error)
            }
        }

        self.codeVC.onDidComplete = { [unowned self] result in
            switch result {
            case .success:
                self.currentContent.value = .name(self.nameVC)
            case .failure(let error):
                print(error)
            }
        }

        self.nameVC.onDidComplete = { [unowned self] result in
            switch result {
            case .success:
                self.currentContent.value = .photo(self.photoVC)
            case .failure(let error):
                print(error)
            }
        }

        self.phoneVC.onDidComplete = { [unowned self] result in
            switch result {
            case .success:
                if let user = User.current() {
                    self.delegate.onboardingView(self, didVerify: user)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    override func getInitialContent() -> OnboardingContent {
        return .phone(self.phoneVC)
    }

    override func didSelectBackButton() {

        switch self.currentContent.value {
        case .reservation(_):
            break
        case .phone(_):
            self.currentContent.value = .reservation(self.reservationVC)
        case .code(_):
            self.currentContent.value = .phone(self.phoneVC)
        case .name(_):
            break
        case .photo(_):
            self.currentContent.value = .name(self.nameVC)
        }
    }
}

extension OnboardingViewController: LoginPhoneViewControllerDelegate {

    func loginPhoneView(_ controller: LoginPhoneViewController, didCompleteWith phone: PhoneNumber) {
        self.codeVC.phoneNumber = phone
    }
}

extension OnboardingViewController: LoginCodeViewControllerDelegate {

    func loginCodeView(_ controller: LoginCodeViewController, didVerify user: PFUser) {
        //self.delegate.onboardingView(self, didVerify: user)
    }
}

extension OnboardingViewController: LoginNameViewControllerDelegate {

    func loginNameViewControllerDidComplete(_ controller: LoginNameViewController) {

    }
}

extension OnboardingViewController: LoginProfilePhotoViewControllerDelegate {
    func loginProfilePhotoViewControllerDidUpdatePhoto(_ controller: LoginProfilePhotoViewController) {
        
    }
}
