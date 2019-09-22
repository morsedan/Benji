//
//  ChannelViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation
import ReactiveSwift
import Parse

class ChannelViewController: ViewController {

    lazy var detailBar = ChannelDetailBar(with: self.channelType, delegate: self.delegate)

    // A Boolean value that determines whether the `MessagesCollectionView`
    /// maintains it's current position when the height of the `MessageInputBar` changes.
    ///
    /// The default value of this property is `false`.
    var maintainPositionOnKeyboardFrameChanged: Bool = false

    var scrollingEnabled: Bool = true
    var didUpdateHeight: ((CGRect, TimeInterval, UIView.AnimationCurve) -> ())?

    let channelType: ChannelType

    lazy var channelCollectionVC = ChannelCollectionViewController()

    private(set) var messageInputView = MessageInputView()
    private(set) var bottomGradientView = GradientView()

    private var bottomOffset: CGFloat {
        var offset: CGFloat = 6
        if let handler = self.keyboardHandler, handler.currentKeyboardHeight == 0 {
            offset += self.view.safeAreaInsets.bottom
        }
        return offset
    }

    var previewAnimator: UIViewPropertyAnimator?
    var previewView: PreviewMessageView?
    var interactiveStartingPoint: CGPoint?
    unowned let delegate: ChannelDetailBarDelegate

    init(channelType: ChannelType, delegate: ChannelDetailBarDelegate) {
        self.delegate = delegate
        self.channelType = channelType
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

        self.registerKeyboardEvents()
        self.view.set(backgroundColor: .background1)
        self.addChild(viewController: self.channelCollectionVC)
        self.view.addSubview(self.detailBar)
        self.view.addSubview(self.bottomGradientView)

        self.view.addSubview(self.messageInputView)
        self.messageInputView.textView.growingDelegate = self

        self.messageInputView.contextButton.onTap { [unowned self] (tap) in
            guard let text = self.messageInputView.textView.text, !text.isEmpty else { return }
            self.send(message: text)
        }

        self.channelCollectionVC.collectionView.onDoubleTap { [unowned self] (doubleTap) in
            if self.messageInputView.textView.isFirstResponder {
                self.messageInputView.textView.resignFirstResponder()
            }
        }

        self.messageInputView.overlayButton.onPan { [unowned self] (pan) in
            pan.delegate = self
            self.handle(pan: pan)
        }

        self.messageInputView.overlayButton.onLongPress { [unowned self] (longPress) in
            longPress.delegate = self
            self.handle(longPress: longPress)
        }

        self.loadMessages(for: self.channelType)
    }

    deinit {
        ChannelManager.shared.selectedChannel = nil 
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard let handler = self.keyboardHandler else { return }

        self.detailBar.size = CGSize(width: self.view.width, height: 60)
        self.detailBar.top = 0
        self.detailBar.centerOnX()

        self.channelCollectionVC.view.size = CGSize(width: self.view.width,
                                                    height: self.view.height - handler.currentKeyboardHeight)
        self.channelCollectionVC.view.top = 0
        self.channelCollectionVC.view.centerOnX()

        self.messageInputView.size = CGSize(width: self.view.width - 32, height: self.messageInputView.textView.currentHeight)
        self.messageInputView.centerOnX()
        self.messageInputView.bottom = self.channelCollectionVC.view.bottom - self.bottomOffset

        let gradientHeight = self.channelCollectionVC.view.height - self.messageInputView.top
        self.bottomGradientView.size = CGSize(width: self.view.width, height: gradientHeight)
        self.bottomGradientView.bottom = self.channelCollectionVC.view.bottom
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
                                          timeStampAsDate: Date(),
                                          status: .unknown)
        self.channelCollectionVC.channelDataSource.append(item: .system(systemMessage))
        self.reset()
    }

    func send(message: String) {
        guard let channel = ChannelManager.shared.selectedChannel else { return }

        let messageType = SystemMessage(avatar: PFUser.current,
                                    context: .casual,
                                    body: message,
                                    id: PFUser.current.objectId!,
                                    isFromCurrentUser: true,
                                    timeStampAsDate: Date(),
                                    status: .sent)
        let type: MessageType = .user(messageType)
        self.channelCollectionVC.channelDataSource.append(item: type)
        self.reset()
        ChannelManager.shared.sendMessage(to: channel, with: message)
    }

    private func reset() {
        self.channelCollectionVC.collectionView.scrollToBottom()
        self.messageInputView.textView.text = String()
        self.messageInputView.textView.alpha = 1
    }
}

extension ChannelViewController: GrowingTextViewDelegate {

    func textViewTextDidChange(_ textView: GrowingTextView) {
        guard let channel = ChannelManager.shared.selectedChannel, textView.text.count > 0 else { return }
        channel.typing()
    }


    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: Theme.animationDuration) {
            self.messageInputView.textView.height = height
            self.view.layoutNow()
        }
    }
}
