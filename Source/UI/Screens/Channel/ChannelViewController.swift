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

    lazy var collectionView: ChannelCollectionView = {
        return ChannelCollectionView()
    }()

    lazy var manager: ChannelCollectionViewManager = {
        return ChannelCollectionViewManager(with: self.collectionView)
    }()

    lazy var inputTextView: InputTextView = {
        let textView = InputTextView()
        textView.delegate = self
        return textView
    }()

    lazy var contextButton = ContextButton()

    var oldTextViewHeight: CGFloat = 48

    let showAnimator = UIViewPropertyAnimator(duration: 0.1,
                                              curve: .linear,
                                              animations: nil)
    let dismissAnimator = UIViewPropertyAnimator(duration: Theme.animationDuration,
                                                 curve: .easeIn,
                                                 animations: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.dataSource = self.manager
        self.collectionView.delegate = self.manager

        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.inputTextView)
        self.view.addSubview(self.contextButton)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)

        self.collectionView.onDoubleTap { [unowned self] (doubleTap) in
            if self.inputTextView.isFirstResponder {
                self.inputTextView.resignFirstResponder()
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.collectionView.scrollToBottom()
    }

    @objc private func keyboardWillShow(notification: Notification) {

        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame: NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height

        self.showAnimator.addAnimations {
            self.inputTextView.bottom = self.view.height - keyboardHeight
            self.collectionView.height = self.view.height - keyboardHeight
            self.collectionView.collectionViewLayout.invalidateLayout()
        }

        self.showAnimator.addCompletion { (position) in
            if position == .end {
                self.collectionView.scrollToBottom()
            }
        }

        self.showAnimator.stopAnimation(true)
        self.showAnimator.startAnimation()
    }

    @objc private func keyboardWillHide(notification: Notification) {

        self.dismissAnimator.addAnimations {
            self.inputTextView.bottom = self.view.height
            self.collectionView.height = self.view.height
        }


        self.dismissAnimator.addCompletion { (position) in
            if position == .end {
                self.collectionView.scrollToBottom()
            }
        }

        self.dismissAnimator.stopAnimation(true)
        self.dismissAnimator.startAnimation()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.collectionView.frame = self.view.bounds

        self.contextButton.size = CGSize(width: 48, height: 48)
        self.contextButton.left = 16
        self.contextButton.bottom = self.view.height - self.view.safeAreaInsets.bottom - 16

        let textViewWidth = self.view.width - self.contextButton.right - 12 - 16
        self.inputTextView.size = CGSize(width: textViewWidth, height: 48)
        self.inputTextView.left = self.contextButton.right + 12
        self.inputTextView.bottom = self.contextButton.bottom
    }

    func loadMessages(for type: ChannelType) {
        //create dummy messages 
    }
}

extension ChannelViewController: GrowingTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: Theme.animationDuration) {
            self.inputTextView.height = height
            self.inputTextView.y = self.inputTextView.y + (self.oldTextViewHeight - height)
            self.view.layoutNow()
            self.oldTextViewHeight = height
        }
    }
}
