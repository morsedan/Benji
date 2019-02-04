//
//  ChannelViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation
import ReactiveSwift

enum CollectionViewLayoutState {
    case bouncy
    case overlaped
}

class ChannelViewController: FullScreenViewController {

    lazy var collectionView: ChannelCollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 90, right: 0)
        let collectionView = ChannelCollectionView(flowLayout: flowLayout)
        return collectionView
    }()

    lazy var manager: ChannelCollectionViewManager = {
        return ChannelCollectionViewManager(with: self.collectionView)
    }()

    let messageInputView = MessageInputView()

    var items: [Message] = []

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
        self.view.addSubview(self.messageInputView)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)

        self.collectionView.onDoubleTap { [unowned self] (doubleTap) in
            if self.messageInputView.textView.isFirstResponder {
                self.messageInputView.textView.resignFirstResponder()
            }
        }
    }

    override func viewIsReadyForLayout() {
        super.viewIsReadyForLayout()

        self.collectionView.frame = self.view.bounds
        
        self.messageInputView.size = CGSize(width: self.view.width, height: 76)
        self.messageInputView.bottom = self.view.height
        self.messageInputView.centerOnX()
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
            self.messageInputView.bottom = self.view.height - keyboardHeight
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
            self.messageInputView.bottom = self.view.height
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
}
