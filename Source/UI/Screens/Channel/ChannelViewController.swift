//
//  ChannelViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation
import ReactiveSwift
import TwilioChatClient

enum CollectionViewLayoutState {
    case bouncy
    case overlaped
}

class ChannelViewController: FullScreenViewController {

    lazy var channelCollectionVC = ChannelCollectionViewController()

    lazy var inputTextView: InputTextView = {
        let textView = InputTextView()
        textView.delegate = self
        return textView
    }()

    lazy var contextButton = ContextButton()
    lazy var bottomGradientView = GradientView()

    var oldTextViewHeight: CGFloat = 48
    private let bottomOffset: CGFloat = 16

    let showAnimator = UIViewPropertyAnimator(duration: 0.1,
                                              curve: .linear,
                                              animations: nil)
    let dismissAnimator = UIViewPropertyAnimator(duration: Theme.animationDuration,
                                                 curve: .easeIn,
                                                 animations: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.set(backgroundColor: .background2)

        self.addChild(viewController: self.channelCollectionVC, toView: self.contentContainer)
        self.contentContainer.addSubview(self.bottomGradientView)

        self.contentContainer.addSubview(self.inputTextView)
        self.inputTextView.growingDelegate = self

        self.contentContainer.addSubview(self.contextButton)
        self.contextButton.onTap { [unowned self] (tap) in
            //show context menu
        }

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)

        self.channelCollectionVC.collectionView.onDoubleTap { [unowned self] (doubleTap) in
            if self.inputTextView.isFirstResponder {
                self.inputTextView.resignFirstResponder()
            }
        }
    }

    @objc private func keyboardWillShow(notification: Notification) {

        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame: NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height

        self.showAnimator.addAnimations {
            self.contextButton.bottom = self.contentContainer.height - keyboardHeight - self.bottomOffset
            self.inputTextView.bottom = self.contextButton.bottom

            self.channelCollectionVC.collectionView.height = self.contentContainer.height - keyboardHeight
            self.channelCollectionVC.collectionView.collectionViewLayout.invalidateLayout()
        }

        self.showAnimator.addCompletion { (position) in
            if position == .end {
                self.channelCollectionVC.collectionView.scrollToBottom()
            }
        }

        self.showAnimator.stopAnimation(true)
        self.showAnimator.startAnimation()
    }

    @objc private func keyboardWillHide(notification: Notification) {

        self.dismissAnimator.addAnimations {
            self.contextButton.bottom = self.contentContainer.height - self.view.safeAreaInsets.bottom - 16
            self.inputTextView.bottom = self.contextButton.bottom
            self.channelCollectionVC.collectionView.height = self.contentContainer.height
            self.channelCollectionVC.collectionView.collectionViewLayout.invalidateLayout()
        }


        self.dismissAnimator.addCompletion { (position) in
            if position == .end {
                self.channelCollectionVC.collectionView.scrollToBottom()
            }
        }

        self.dismissAnimator.stopAnimation(true)
        self.dismissAnimator.startAnimation()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.contentContainer.height = self.view.height
        self.contentContainer.top = 0

        self.channelCollectionVC.view.frame = self.contentContainer.bounds

        self.contextButton.size = CGSize(width: 48, height: 48)
        self.contextButton.left = 16
        self.contextButton.bottom = self.contentContainer.height - self.view.safeAreaInsets.bottom - 16

        let textViewWidth = self.contentContainer.width - self.contextButton.right - 12 - 16
        self.inputTextView.size = CGSize(width: textViewWidth, height: self.inputTextView.currentHeight)
        self.inputTextView.left = self.contextButton.right + 12
        self.inputTextView.bottom = self.contextButton.bottom

        let gradientHeight = self.contentContainer.height - self.contextButton.top - 10
        self.bottomGradientView.size = CGSize(width: self.contentContainer.width, height: gradientHeight)
        self.bottomGradientView.bottom = self.contentContainer.height
        self.bottomGradientView.centerOnX()
    }

    func loadMessages(for type: ChannelType) {
        //create dummy messages
        self.channelCollectionVC.loadMessages()
        
    }
}

extension ChannelViewController: GrowingTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: Theme.animationDuration) {
            self.inputTextView.height = height
            self.inputTextView.bottom = self.contextButton.bottom
            self.oldTextViewHeight = height
        }
    }
}
