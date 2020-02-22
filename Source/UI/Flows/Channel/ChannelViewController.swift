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
import TwilioChatClient
import TMROFutures

class ChannelViewController: FullScreenViewController {

    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
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
    lazy var collectionViewManager = ChannelCollectionViewManager(with: self.collectionView, for: self.channelType)

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

        self.view.addSubview(self.blurView)
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.detailBar)

        self.view.addSubview(self.messageInputView)
        self.messageInputView.height = self.messageInputView.minHeight

        self.collectionView.dataSource = self.collectionViewManager
        self.collectionView.delegate = self.collectionViewManager

        self.messageInputView.onPanned = { [unowned self] (panRecognizer) in
            self.handle(pan: panRecognizer)
        }

        self.collectionView.onDoubleTap { [unowned self] (doubleTap) in
            if self.messageInputView.textView.isFirstResponder {
                self.messageInputView.textView.resignFirstResponder()
            }
        }

        self.disposables += ChannelManager.shared.activeChannel.producer
            .on { [unowned self] (channel) in

                guard let strongChannel = channel else {
                    self.collectionView.activityIndicator.startAnimating()
                    self.collectionViewManager.reset()
                    return
                }

                strongChannel.delegate = self
                self.loadMessages()
                self.view.setNeedsLayout()
        }.start()

        self.subscribeToClient()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if MessageSupplier.shared.sections.count > 0 {
            self.collectionViewManager.set(newSections: MessageSupplier.shared.sections, animate: true, completion: nil)
        } else {
            MessageSupplier.shared.didGetLastSections = { [unowned self] sections in
                self.collectionViewManager.set(newSections: sections, animate: true, completion: nil)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.blurView.expandToSuperviewSize()

        guard let handler = self.keyboardHandler else { return }

        self.detailBar.size = CGSize(width: self.view.width, height: 80)
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

        ChannelManager.shared.activeChannel.value = nil
        self.collectionViewManager.reset()
    }

    @discardableResult
    func send(message: String,
              context: MessageContext = .casual,
              attributes: [String : Any]) -> Future<Void> {
        let promise = Promise<Void>()

        guard let channel = ChannelManager.shared.activeChannel.value,
            let current = User.current(),
            let objectId = current.objectId else { return promise }

        var mutableAttributes = attributes
        mutableAttributes["updateId"] = UUID().uuidString

        let systemMessage = SystemMessage(avatar: current,
                                          context: context,
                                          text: message,
                                          isFromCurrentUser: true,
                                          createdAt: Date(),
                                          authorId: objectId,
                                          messageIndex: nil,
                                          status: .sent,
                                          id: String(),
                                          attributes: mutableAttributes)

        self.collectionViewManager.append(item: systemMessage) { [unowned self] in
            self.collectionView.scrollToEnd()
        }
        ChannelManager.shared.sendMessage(to: channel,
                                          with: message,
                                          context: context,
                                          attributes: mutableAttributes)
            .observeValue(with: { (sentMessage) in
                if context == .emergency {
                    UserNotificationManager.shared.notify(channel: channel, message: sentMessage)
                }
                promise.resolve(with: ())
            })

        self.messageInputView.reset()

        return promise
    }
}

extension ChannelViewController: TCHChannelDelegate {

    func chatClient(_ client: TwilioChatClient,
                    channel: TCHChannel,
                    member: TCHMember,
                    updated: TCHMemberUpdate) {
        print("Channel Member updated")
    }

    func chatClient(_ client: TwilioChatClient,
                    channel: TCHChannel,
                    message: TCHMessage,
                    updated: TCHMessageUpdate) {
        
        self.collectionViewManager.updateItem(with: message)
    }
}
