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

class OnboardingViewController: NavigationBarViewController {

    lazy var reservationVC = ReservationViewController()
    lazy var phoneVC = LoginPhoneViewController(with: self)
    lazy var codeVC = LoginCodeViewController(with: self)
    lazy var nameVC = LoginNameViewController(with: self)
    lazy var photoVC = LoginProfilePhotoViewController(with: self)

    lazy var currentContent = MutableProperty<OnboardingContent>(.reservation(self.reservationVC))
    private var currentCenterVC: UIViewController?
    
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

        self.currentContent.producer
            .skipRepeats()
            .on { [unowned self] (contentType) in
                self.switchContent()
        }.start()
    }

    private func switchContent() {

        UIView.animate(withDuration: Theme.animationDuration, animations: {
            self.titleLabel.alpha = 0
            self.titleLabel.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)

            self.descriptionLabel.alpha = 0
            self.descriptionLabel.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)

            self.currentCenterVC?.view.alpha = 0
            self.backButton.alpha = 0

        }) { (completed) in

            self.currentCenterVC?.removeFromParentSuperview()

            self.updateLabels()

            self.currentCenterVC = self.currentContent.value.vc
            let showBackButton = self.currentContent.value.showBackButton

            if let contentVC = self.currentCenterVC {
                self.addChild(viewController: contentVC, toView: self.scrollView)
            }

            self.view.setNeedsLayout()

            UIView.animate(withDuration: Theme.animationDuration) {
                self.titleLabel.alpha = 1
                self.titleLabel.transform = .identity

                self.descriptionLabel.alpha = 1
                self.descriptionLabel.transform = .identity

                self.currentCenterVC?.view.alpha = 1
                self.backButton.alpha = showBackButton ? 1 : 0
            }
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
