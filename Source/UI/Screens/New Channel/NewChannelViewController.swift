//
//  ChannelPurposeViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 9/8/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse
import TMROFutures
import TMROLocalization
import ReactiveSwift

protocol NewChannelViewControllerDelegate: class {
    func newChannelView(_ controller: NewChannelViewController,
                        didCreate channel: ChannelType)
}

enum NewChannelContent: Equatable {
    case purpose(PurposeViewController)
    case favorites(FavoritesViewController)
}

class NewChannelViewController: NavigationBarViewController {

    lazy var purposeVC = PurposeViewController()
    lazy var favoritesVC = FavoritesViewController()
    lazy var currentContent = MutableProperty<NewChannelContent>(.purpose(self.purposeVC))
    private var currentCenterVC: UIViewController?
    private let centerContainer = View()
    private var centerContainerHeight: CGFloat = 0

    let button = NewChannelButton()

    unowned let delegate: NewChannelViewControllerDelegate

    init(delegate: NewChannelViewControllerDelegate) {
        self.delegate = delegate
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    required init?(withObject object: DeepLinkable) {
        fatalError("init(withObject:) has not been implemented")
    }

    override func initializeViews() {
        super.initializeViews()

        self.view.addSubview(self.centerContainer)
        self.view.set(backgroundColor: .background2)

        self.view.addSubview(self.button)
        self.button.onTap { [unowned self] (tap) in
            self.buttonTapped()
        }

        self.currentContent.producer
            .skipRepeats()
            .on { [unowned self] (contentType) in
                self.switchContent()
        }.start()

        self.backButton.onTap { [unowned self] (tap) in
            self.currentContent.value = .purpose(self.purposeVC)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.button.size = CGSize(width: 60, height: 60)
        self.button.right = self.view.width - 16
        self.button.bottom = self.view.height - self.view.safeAreaInsets.bottom - 10

        self.centerContainer.size = CGSize(width: self.view.width,
                                           height: self.centerContainerHeight)
        self.centerContainer.top = self.lineView.bottom + 30
        self.centerContainer.centerOnX()

        self.currentCenterVC?.view.frame = self.centerContainer.bounds

        self.scrollView.contentSize = CGSize(width: self.view.width, height: self.centerContainer.bottom + 20)
    }

    override func getTitle() -> Localized {
        switch self.currentContent.value {
        case .purpose(_):
            return "NEW CONVERSATION"
        case .favorites(_):
            return LocalizedString(id: "",
                                   arguments: [self.purposeVC.textField.text!],
                                   default: "ADD PEOPLE TO: @()")
        }
    }

    override func getDescription() -> Localized {
        switch self.currentContent.value {
        case .purpose(_):
            return "Add a name and description to help frame the conversation."
        case .favorites(_):
            return LocalizedString(id: "",
                                   arguments: [self.purposeVC.textView.text!],
                                   default: "Descriptoin: @()")
        }
    }

    private func updateButton() {
        switch self.currentContent.value {
        case .purpose(_):
            self.button.iconImageView.image = UIImage(systemName: "person.badge.plus")
        case .favorites(_):
            self.button.iconImageView.image = UIImage(systemName: "square.and.pencil")
        }

        self.button.layoutNow()
    }

    func buttonTapped() {
        switch self.currentContent.value {
        case .purpose(_):
            self.currentContent.value = .favorites(self.favoritesVC)
        case .favorites(_):
            guard let title = self.purposeVC.textField.text,
                let description = self.purposeVC.textView.text else { return }

            self.createChannel(with: "",
                               title: title,
                               description: description)
        }
    }

    private func switchContent() {

        UIView.animate(withDuration: Theme.animationDuration, animations: {
            self.titleLabel.alpha = 0
            self.titleLabel.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)

            self.descriptionLabel.alpha = 0
            self.descriptionLabel.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)

            self.centerContainer.alpha = 0
            self.backButton.alpha = 0 
        }) { (completed) in

            self.currentCenterVC?.removeFromParentSuperview()
            var newContentVC: UIViewController?
            var showBackButton = false
            switch self.currentContent.value {
            case .purpose(let vc):
                newContentVC = vc
                self.centerContainerHeight = 500
            case .favorites(let vc):
                newContentVC = vc
                self.centerContainerHeight = 500
                showBackButton = true
            }

            self.updateLabels()
            self.updateButton()

            self.currentCenterVC = newContentVC

            if let contentVC = self.currentCenterVC {
                self.addChild(viewController: contentVC, toView: self.centerContainer)
            }

            self.view.setNeedsLayout()

            UIView.animate(withDuration: Theme.animationDuration) {
                self.titleLabel.alpha = 1
                self.titleLabel.transform = .identity

                self.descriptionLabel.alpha = 1
                self.descriptionLabel.transform = .identity

                self.centerContainer.alpha = 1
                self.backButton.alpha = showBackButton ? 1 : 0
            }
        }
    }

    private func createChannel(with inviteeIdentifier: String,
                               title: String,
                               description: String) {

        self.button.isLoading = true

        ChannelSupplier.createChannel(channelName: title,
                                     channelDescription: description,
                                     type: .private)
            .joinIfNeeded()
            .sendInitialMessage()
            .invite(personUserID: inviteeIdentifier)
            .withProgressBanner("Creating conversation")
            .withErrorBanner()
            .ignoreUserInteractionEventsUntilDone(for: self.view)
            .observe { (result) in
                self.button.isLoading = false
                switch result {
                case .success(let channel):
                    self.delegate.newChannelView(self, didCreate: .channel(channel))
                case .failure(let error):
                    if let tomorrowError = error as? ClientError {
                        print(tomorrowError.localizedDescription)
                    } else {
                        print(error.localizedDescription)
                    }
                }
        }
    }

}

