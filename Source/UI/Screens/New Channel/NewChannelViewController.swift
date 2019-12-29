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

class NewChannelViewController: NavigationBarViewController, KeyboardObservable {

    lazy var purposeVC = PurposeViewController()
    lazy var favoritesVC = FavoritesViewController()
    lazy var currentContent = MutableProperty<NewChannelContent>(.purpose(self.purposeVC))
    private var currentCenterVC: UIViewController?
    private let centerContainer = View()
    private var centerVCHeight: CGFloat?

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

        self.registerKeyboardEvents()

        self.purposeVC.textFieldDidBegin = { [unowned self] in
            UIView.animate(withDuration: Theme.animationDuration) {
                self.titleLabel.alpha = 0.2
                self.descriptionLabel.alpha = 0.2
                self.lineView.alpha = 0.2
                self.purposeVC.textViewTitleLabel.alpha = 0.2
                self.purposeVC.textView.alpha = 0.2
            }
        }

        self.purposeVC.textFieldDidEnd = { [unowned self] in
            UIView.animate(withDuration: Theme.animationDuration) {
                self.titleLabel.alpha = 1
                self.descriptionLabel.alpha = 1
                self.lineView.alpha = 1
                self.purposeVC.textViewTitleLabel.alpha = 1
                self.purposeVC.textView.alpha = 1
            }
        }

        self.purposeVC.textViewDidBegin = { [unowned self] in
            UIView.animate(withDuration: Theme.animationDuration) {
                self.titleLabel.alpha = 0.2
                self.descriptionLabel.alpha = 0.2
                self.lineView.alpha = 0.2
                self.purposeVC.textFieldTitleLabel.alpha = 0.2
                self.purposeVC.textField.alpha = 0.2
            }
        }

        self.purposeVC.textViewDidEnd = { [unowned self] in
            UIView.animate(withDuration: Theme.animationDuration) {
                self.titleLabel.alpha = 1
                self.descriptionLabel.alpha = 1
                self.lineView.alpha = 1
                self.purposeVC.textFieldTitleLabel.alpha = 1
                self.purposeVC.textField.alpha = 1
            }
        }

        self.purposeVC.textFieldTextDidChange = { [unowned self] text in
            self.button.isEnabled = !text.isEmpty
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.button.size = CGSize(width: 60, height: 60)
        self.button.right = self.view.width - 16
        self.button.bottom = self.view.height - self.view.safeAreaInsets.bottom - 10

        let height = self.centerVCHeight ?? self.view.height - self.lineView.bottom
        self.centerContainer.size = CGSize(width: self.view.width,
                                           height: height)
        self.centerContainer.top = self.lineView.bottom
        self.centerContainer.centerOnX()

        self.currentCenterVC?.view.frame = self.centerContainer.bounds

        let offset: CGFloat = self.keyboardHandler?.currentKeyboardHeight ?? 20
        self.scrollView.contentSize = CGSize(width: self.view.width, height: self.centerContainer.bottom + offset)

        guard let handler = self.keyboardHandler else { return }
        let diff = self.view.height - handler.currentKeyboardHeight
        if diff < self.centerContainer.bottom {
            let offset = self.centerContainer.bottom - diff
            self.scrollView.setContentOffset(CGPoint(x: 0, y: offset), animated: false)
        }
    }

    override func getTitle() -> Localized {
        switch self.currentContent.value {
        case .purpose(_):
            return "NEW CONVERSATION"
        case .favorites(_):
            return LocalizedString(id: "",
                                   arguments: [self.purposeVC.textField.text!],
                                   default: "ADD FAVORITES TO:\n@(foo)")
        }
    }

    override func getDescription() -> Localized {
        switch self.currentContent.value {
        case .purpose(_):
            return "Add a name and description to help frame the conversation."
        case .favorites(_):
            if let text = self.purposeVC.textView.text, !text.isEmpty {
                return text
            } else {
                return "No description given."
            }
        }
    }

    func buttonTapped() {
        switch self.currentContent.value {
        case .purpose(_):
            self.currentContent.value = .favorites(self.favoritesVC)
        case .favorites(_):
            guard let title = self.purposeVC.textField.text,
                let description = self.purposeVC.textView.text else { return }

            let avatar = self.favoritesVC.collectionViewManager.onSelectedItem.value.map { (orbItem) -> Avatar in
                return orbItem.item.avatar.value
            }

            if let user = avatar as? User {
                self.createChannel(with: user,
                                   title: title,
                                   description: description)
            }
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
                self.centerVCHeight = vc.totalHeight
            case .favorites(let vc):
                newContentVC = vc
                showBackButton = true
                self.centerVCHeight = nil
            }

            self.updateLabels()
            self.button.update(for: self.currentContent.value)

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

    private func createChannel(with user: User,
                               title: String,
                               description: String) {

        self.button.isLoading = true

        ChannelSupplier.createChannel(channelName: title,
                                      channelDescription: description,
                                      type: .private)
            .joinIfNeeded()
            .invite(user: user)
            .withProgressBanner("Creating conversation")
            .withErrorBanner()
            .ignoreUserInteractionEventsUntilDone(for: self.view)
            .observe { (result) in
                self.button.isLoading = false
                switch result {
                case .success(let channel):
                    guard let handle = User.current()?.handle else { return }
                    let message = "\(handle) set the conversation purpose to: \(channel.channelDescription)"
                    ChannelManager.shared.sendMessage(to: channel, with: message, context: .status)
                        .observe { (result) in
                            self.delegate.newChannelView(self, didCreate: .channel(channel))
                    }
                case .failure(let error):
                    if let tomorrowError = error as? ClientError {
                        print(tomorrowError.localizedDescription)
                    } else {
                        print(error.localizedDescription)
                    }
                }
        }
    }

    func handleKeyboard(frame: CGRect,
                        with animationDuration: TimeInterval,
                        timingCurve: UIView.AnimationCurve) {

        UIView.animate(withDuration: animationDuration, animations: {
            self.view.layoutNow()
        })
    }
}

