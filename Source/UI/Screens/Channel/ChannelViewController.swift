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
        self.messageInputView.height = 44
        self.messageInputView.textView.growingDelegate = self

        self.collectionView.dataSource = self.collectionViewManager
        self.collectionView.delegate = self.collectionViewManager

        self.messageInputView.onPanned = { [unowned self] (panRecognizer) in
            self.handle(pan: panRecognizer)
        }

        self.messageInputView.onAlertMessageConfirmed = { [unowned self] in
            self.send(message: self.messageInputView.textView.text,
                      context: .emergency,
                      attributes: [:])
        }

        self.collectionView.onDoubleTap { [unowned self] (doubleTap) in
            if self.messageInputView.textView.isFirstResponder {
                self.messageInputView.textView.resignFirstResponder()
            }
        }

        self.disposables += ChannelManager.shared.selectedChannel.producer
        .on { [unowned self] (channel) in
            
            guard let _ = channel else {
                self.collectionView.activityIndicator.startAnimating()
                self.collectionViewManager.reset()
                return
            }

            self.loadMessages()
            self.view.setNeedsLayout()
        }.start()

        self.subscribeToClient()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard let handler = self.keyboardHandler else { return }

        self.detailBar.size = CGSize(width: self.view.width, height: 60)
        self.detailBar.top = 0
        self.detailBar.centerOnX()

        let keyboardHeight = handler.currentKeyboardHeight
        let height = self.view.height - keyboardHeight

        self.collectionView.size = CGSize(width: self.view.width, height: height)
        self.collectionView.top = 0
        self.collectionView.centerOnX()

        self.messageInputView.width = self.view.width - Theme.contentOffset * 2
        var messageBottomOffset: CGFloat = 10
        if keyboardHeight == 0, let window = UIWindow.topWindow() {
            messageBottomOffset += window.safeAreaInsets.bottom
        }

        self.messageInputView.bottom = self.collectionView.bottom - messageBottomOffset
        self.messageInputView.centerOnX()
    }

    override func viewWasDismissed() {
        super.viewWasDismissed()

        ChannelManager.shared.selectedChannel.value = nil
    }

    @discardableResult
    func send(message: String,
              context: MessageContext = .casual,
              attributes: [String : Any]) -> Future<Void> {
        let promise = Promise<Void>()

        guard let channel = ChannelManager.shared.selectedChannel.value,
            let current = User.current(),
            let objectId = current.objectId else { return promise }

        let systemMessage = SystemMessage(avatar: current,
                                          context: context,
                                          text: message,
                                          isFromCurrentUser: true,
                                          createdAt: Date(),
                                          authorId: objectId,
                                          messageIndex: nil,
                                          status: .sent,
                                          id: objectId)

        self.collectionViewManager.append(item: systemMessage) { [unowned self] in
            self.collectionView.scrollToBottom()
        }
        ChannelManager.shared.sendMessage(to: channel,
                                          with: message,
                                          attributes: attributes)
            .observe { (result) in
                switch result {
                case .success:
                    promise.resolve(with: ())
                case .failure(let error):
                    promise.reject(with: error)
                }
        }

        self.messageInputView.reset()

        return promise
    }
}

extension ChannelViewController: GrowingTextViewDelegate {

    func textViewTextDidChange(_ textView: GrowingTextView) {
        guard let channel = ChannelManager.shared.selectedChannel.value,
            textView.text.count > 0 else { return }
        
        channel.typing()
    }


    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: Theme.animationDuration) {
            self.messageInputView.textView.height = height
            self.view.layoutNow()
        }
    }
}
