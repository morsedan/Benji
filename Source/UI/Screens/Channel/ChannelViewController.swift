//
//  ChannelViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation
import ReactiveSwift

class ChannelViewController: ViewController, ScrolledModalControllerPresentable {

    var topMargin: CGFloat {
        return self.view.safeAreaInsets.top + 60
    }

    var scrollView: UIScrollView? {
        return self.channelCollectionVC.collectionView
    }

    var scrollingEnabled: Bool = true
    var didUpdateHeight: ((CGFloat, TimeInterval) -> ())?

    let channelType: ChannelType

    lazy var channelCollectionVC = ChannelCollectionViewController()
    lazy var inputTextView: InputTextView = {
        let textView = InputTextView()
        textView.delegate = self
        return textView
    }()

    private(set) var contextButton = ContextButton()
    private(set) var bottomGradientView = GradientView()

    var oldTextViewHeight: CGFloat = 48
    let bottomOffset: CGFloat = 16

    let showAnimator = UIViewPropertyAnimator(duration: 0.1,
                                              curve: .linear,
                                              animations: nil)
    let dismissAnimator = UIViewPropertyAnimator(duration: 0.1,
                                                 curve: .easeIn,
                                                 animations: nil)

    init(channelType: ChannelType) {
        self.channelType = channelType
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

        self.view.set(backgroundColor: .background3)
        
        self.addChild(viewController: self.channelCollectionVC)
        self.view.addSubview(self.bottomGradientView)

        self.view.addSubview(self.inputTextView)
        self.inputTextView.growingDelegate = self

        self.view.addSubview(self.contextButton)
        self.contextButton.onTap { [unowned self] (tap) in
            guard let text = self.inputTextView.text, !text.isEmpty else { return }
           // self.sendSystem(message: text)
            self.send(message: text)
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

        self.loadMessages(for: self.channelType)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.channelCollectionVC.view.frame = self.view.bounds

        self.contextButton.size = CGSize(width: 48, height: 48)
        self.contextButton.left = 16
        self.contextButton.bottom = self.view.height - self.view.safeAreaInsets.bottom

        let textViewWidth = self.view.width - self.contextButton.right - 12 - 16
        self.inputTextView.size = CGSize(width: textViewWidth, height: self.inputTextView.currentHeight)
        self.inputTextView.left = self.contextButton.right + 12
        self.inputTextView.bottom = self.contextButton.bottom

        let gradientHeight = self.view.height - self.contextButton.top
        self.bottomGradientView.size = CGSize(width: self.view.width, height: gradientHeight)
        self.bottomGradientView.bottom = self.view.height
        self.bottomGradientView.centerOnX()
    }

    func loadMessages(for type: ChannelType) {
        self.channelCollectionVC.loadMessages(for: type)
    }

    func sendSystem(message: String) {
        let systemMessage = SystemMessage(avatar: Lorem.avatar(),
                                          context: Lorem.context(),
                                          body: message,
                                          id: String(Lorem.randomString()),
                                          isFromCurrentUser: true,
                                          timeStampAsDate: Date())
        self.channelCollectionVC.channelDataSource.append(item: .system(systemMessage))
        self.reset()
    }

    func send(message: String) {
        guard let channel = ChannelManager.shared.selectedChannel else { return }

        ChannelManager.shared.sendMessage(to: channel, with: message)
        self.reset()
    }

    private func reset() {
        self.channelCollectionVC.collectionView.scrollToBottom()
        self.inputTextView.text = String()
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
