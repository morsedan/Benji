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

class ChannelViewController: FullScreenViewController {

    lazy var detailBar = ChannelDetailBar(with: self.channelType, delegate: self.delegate)

    // A Boolean value that determines whether the `MessagesCollectionView`
    /// maintains it's current position when the height of the `MessageInputBar` changes.
    ///
    /// The default value of this property is `false`.
    var maintainPositionOnKeyboardFrameChanged: Bool = false

    var scrollingEnabled: Bool = true
    var didUpdateHeight: ((CGRect, TimeInterval, UIView.AnimationCurve) -> ())?

    let channelType: ChannelType

    let disposables = CompositeDisposable()

    lazy var collectionView = ChannelCollectionView()
    lazy var collectionViewManager: ChannelCollectionViewManager = {
        let manager = ChannelCollectionViewManager(with: self.collectionView)
        return manager
    }()

    private(set) var messageInputView = MessageInputView()

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

    deinit {
        self.disposables.dispose()
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

        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.detailBar)

        self.view.addSubview(self.messageInputView)
        self.messageInputView.textView.growingDelegate = self

        self.messageInputView.onPanned = { [unowned self] (panRecognizer) in
            self.handle(pan: panRecognizer)
        }

        self.messageInputView.onAlertMessageConfirmed = { [unowned self] in
            self.send(message: self.messageInputView.textView.text, context: .emergency)
        }

        self.collectionView.onDoubleTap { [unowned self] (doubleTap) in
            if self.messageInputView.textView.isFirstResponder {
                self.messageInputView.textView.resignFirstResponder()
            }
        }

        self.disposables += ChannelManager.shared.selectedChannel.producer
        .on { [unowned self] (channel) in
            
            guard let strongChannel = channel else {
                self.collectionView.activityIndicator.startAnimating()
                self.collectionViewManager.reset()
                return
            }

            self.loadMessages()
            self.view.setNeedsLayout()
        }.start()
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
    }

    func loadMessages(for type: ChannelType) {
        self.channelCollectionVC.loadMessages(for: type)
    }

    func send(message: String, context: MessageContext = .casual) {
        guard let channel = ChannelManager.shared.selectedChannel,
            let current = User.current(),
            let objectId = current.objectId else { return }

        let systemMessage = SystemMessage(avatar: current,
                                          context: context,
                                          text: message,
                                          isFromCurrentUser: true,
                                          createdAt: Date(),
                                          authorId: objectId,
                                          messageIndex: nil,
                                          status: .sent,
                                          id: objectId)
        self.channelCollectionVC.channelDataSource.append(item: systemMessage)
        self.reset()
        ChannelManager.shared.sendMessage(to: channel, with: message)
    }

    private func reset() {
        self.channelCollectionVC.collectionView.scrollToBottom()
        self.messageInputView.textView.text = String()
        self.messageInputView.textView.alpha = 1
        self.messageInputView.resetInputViews()
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
