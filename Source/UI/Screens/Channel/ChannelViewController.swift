//
//  ChannelViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation
import ReactiveSwift

class ChannelViewController: ViewController, ScrolledModalControllerPresentable, KeyboardObservable, UIGestureRecognizerDelegate {

    var topMargin: CGFloat {
        guard let topInset = UIWindow.topWindow()?.safeAreaInsets.top else { return 0 }
        return topInset + 60
    }

    var scrollView: UIScrollView? {
        return self.channelCollectionVC.collectionView
    }

    var scrollingEnabled: Bool = true
    var didUpdateHeight: ((CGFloat, TimeInterval, UIView.AnimationCurve) -> ())?

    let channelType: ChannelType

    lazy var channelCollectionVC = ChannelCollectionViewController()

    private let messageInputView = MessageInputView()
    private(set) var bottomGradientView = GradientView()

    private var bottomOffset: CGFloat {
        var offset: CGFloat = 16
        if let handler = self.keyboardHandler, handler.currentKeyboardHeight == 0 {
            offset += self.view.safeAreaInsets.bottom
        }
        return offset
    }

    var previewAnimator: UIViewPropertyAnimator?
    var previewView: PreviewMessageView?
    var interactiveStartingPoint: CGPoint?

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

    override func initializeViews() {
        super.initializeViews()

        self.registerKeyboardEvents()
        self.view.set(backgroundColor: .background2)

        self.addChild(viewController: self.channelCollectionVC)
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

        self.loadMessages(for: self.channelType)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard let handler = self.keyboardHandler else { return }

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
        self.messageInputView.textView.text = String()
        self.messageInputView.textView.alpha = 1
    }

    func handleKeyboard(height: CGFloat, with animationDuration: TimeInterval, timingCurve: UIView.AnimationCurve) {

        let animator = UIViewPropertyAnimator(duration: animationDuration, curve: timingCurve) {
            self.channelCollectionVC.collectionView.height = self.view.height - height
        }

        animator.startAnimation()
        self.channelCollectionVC.collectionView.scrollToBottom(animated: true)
    }

    private func handle(pan: UIPanGestureRecognizer) {
        guard let text = self.messageInputView.textView.text, !text.isEmpty else { return }

        let currentLocation = pan.location(in: self.view)
        let startingPoint: CGPoint

        if let point = self.interactiveStartingPoint {
            startingPoint = point
        } else {
            // Initial location
            startingPoint = pan.location(in: nil)
            self.interactiveStartingPoint = startingPoint
        }
        let totalOffset = self.messageInputView.height + 10
        var diff = (startingPoint.y - currentLocation.y)
        diff -= totalOffset
        var progress = diff / 100
        progress = clamp(progress, 0.0, 1.0)

        switch pan.state {
        case .possible:
            break
        case .began:
            self.previewView = PreviewMessageView()
            self.previewView?.textView.text = self.messageInputView.textView.text
            self.previewView?.backgroundView.alpha = 0.0
            self.view.insertSubview(self.previewView!, aboveSubview: self.messageInputView)
            self.view.addSubview(self.previewView!)
            self.previewView?.frame = self.messageInputView.frame
            self.previewView?.layoutNow()
            let top = self.messageInputView.top - totalOffset

            self.previewAnimator = UIViewPropertyAnimator(duration: Theme.animationDuration,
                                                          curve: .easeInOut,
                                                          animations: nil)
            self.previewAnimator?.addAnimations {
                UIView.animateKeyframes(withDuration: 0,
                                        delay: 0,
                                        animations: {
                                            UIView.addKeyframe(withRelativeStartTime: 0,
                                                               relativeDuration: 0.3,
                                                               animations: {
                                                                self.messageInputView.textView.alpha = 0
                                                                self.previewView?.backgroundView.alpha = 1
                                            })

                                            UIView.addKeyframe(withRelativeStartTime: 0.6,
                                                               relativeDuration: 0.4,
                                                               animations: {
                                                                self.channelCollectionVC.collectionView.collectionViewLayout.collectionView?.contentInset.bottom += totalOffset
                                                                self.channelCollectionVC.collectionView.collectionViewLayout.invalidateLayout()
                                            })

                                            UIView.addKeyframe(withRelativeStartTime: 0,
                                                               relativeDuration: 1,
                                                               animations: {
                                                                self.previewView?.top = top
                                                                self.view.setNeedsLayout()
                                            })

                }) { (completed) in }
            }

            self.previewAnimator?.addCompletion({ (position) in
                if position == .end {
                    self.sendSystem(message: text)
                    self.previewView?.removeFromSuperview()
                }
                if position == .start {
                    self.previewView?.removeFromSuperview()
                }

                self.channelCollectionVC.collectionView.collectionViewLayout.collectionView?.contentInset.bottom = 80
                self.channelCollectionVC.collectionView.collectionViewLayout.invalidateLayout()
            })
            self.previewAnimator?.pauseAnimation()
        case .changed:
            if let preview = self.previewView {
                let translation = pan.translation(in: preview)
                preview.x = self.messageInputView.x + translation.x
                self.previewAnimator?.fractionComplete = (translation.y * -1) / 100
            }
        case .ended:
            self.previewAnimator?.isReversed = progress <= 0.5
            self.previewAnimator?.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        case .cancelled:
            self.previewAnimator?.finishAnimation(at: .end)
        case .failed:
            self.previewAnimator?.finishAnimation(at: .end)
        @unknown default:
            break
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension ChannelViewController: GrowingTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: Theme.animationDuration) {
            self.messageInputView.textView.height = height
            self.view.layoutNow()
        }
    }
}
