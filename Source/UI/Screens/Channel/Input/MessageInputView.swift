//
//  MessageInputView.swift
//  Benji
//
//  Created by Benji Dodgson on 8/17/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class MessageInputView: View {

    var onPanned: ((UIPanGestureRecognizer) -> Void)?

    private(set) var minHeight: CGFloat = 44
    var oldTextViewHeight: CGFloat = 44

    let textView = InputTextView()
    let overlayButton = UIButton()
    private let alertProgressView = AlertProgressView()
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterialDark))
    private lazy var alertConfirmation = AlertConfirmationView()

    private var alertAnimator: UIViewPropertyAnimator?
    private let selectionFeedback = UIImpactFeedbackGenerator(style: .rigid)

    private(set) var messageContext: MessageContext = .casual

    override func initializeSubviews() {
        super.initializeSubviews()

        self.set(backgroundColor: .backgroundWithAlpha)

        self.addSubview(self.blurView)
        self.addSubview(self.alertProgressView)
        self.alertProgressView.set(backgroundColor: .red)
        self.alertProgressView.size = .zero 
        self.addSubview(self.textView)
        self.textView.minHeight = self.minHeight
        self.textView.growingDelegate = self
        self.addSubview(self.overlayButton)

        self.overlayButton.onTap { [unowned self] (tap) in
            if !self.textView.isFirstResponder {
                self.textView.becomeFirstResponder()
            }
        }

        let panRecognizer = UIPanGestureRecognizer { [unowned self] (recognizer) in
            self.onPanned?(recognizer)
        }
        panRecognizer.delegate = self
        self.overlayButton.addGestureRecognizer(panRecognizer)

        let longPressRecognizer = UILongPressGestureRecognizer { [unowned self] (recognizer) in
            self.handle(longPress: recognizer)
        }
        longPressRecognizer.delegate = self
        self.overlayButton.addGestureRecognizer(longPressRecognizer)

        self.layer.masksToBounds = true
        self.layer.borderWidth = Theme.borderWidth
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
        self.layer.cornerRadius = Theme.cornerRadius

        self.alertConfirmation.didCancel = { [unowned self] in
            self.resetAlertProgress()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let textViewWidth = self.width
        self.textView.size = CGSize(width: textViewWidth, height: self.textView.currentHeight)
        self.textView.left = 0
        self.textView.top = 0

        self.alertProgressView.height = self.height

        self.overlayButton.frame = self.bounds
        self.blurView.frame = self.bounds

        self.layer.borderColor = self.messageContext.color.color.cgColor
    }

    private func handle(longPress: UILongPressGestureRecognizer) {

        switch longPress.state {
        case .possible:
            break
        case .began:
            self.startAlertAnimation()
        case .changed:
            break
        case .ended, .cancelled, .failed:
            self.endAlertAnimation()
        @unknown default:
            break
        }
    }

    private func startAlertAnimation() {
        self.messageContext = .emergency
        self.alertAnimator?.stopAnimation(true)
        self.alertAnimator?.pausesOnCompletion = true
        self.selectionFeedback.impactOccurred()

        self.alertAnimator = UIViewPropertyAnimator(duration: 1.0,
                                                    curve: .linear,
                                                    animations: { [unowned self] in
            self.alertProgressView.size = CGSize(width: self.width, height: self.height)
        })

        self.alertAnimator?.startAnimation()

        UIView.animate(withDuration: 1.0, delay: 0, options: [.curveEaseIn, .repeat, .autoreverse], animations: {
            self.alertProgressView.alpha = 0
            self.selectionFeedback.impactOccurred()
        }, completion: nil)
    }
    
    private func endAlertAnimation() {
        if let fractionComplete = self.alertAnimator?.fractionComplete,
            fractionComplete == CGFloat(0.0) {

            self.alertAnimator?.stopAnimation(true)
            self.showAlertConfirmation()
        } else {
            self.alertAnimator?.stopAnimation(true)
            self.messageContext = .casual
            self.alertAnimator = UIViewPropertyAnimator(duration: 0.5,
                                                        curve: .linear,
                                                        animations: { [unowned self] in
                                                            self.alertProgressView.size = CGSize(width: 0, height: self.height)
                                                            self.layer.borderColor = self.messageContext.color.color.cgColor
            })
            self.alertAnimator?.startAnimation()
        }
    }

    func reset() {
        self.textView.text = String()
        self.textView.alpha = 1
        self.resetInputViews()
        self.resetAlertProgress()
    }

    func resetAlertProgress() {
        self.messageContext = .casual
        self.alertProgressView.width = 0
        self.alertProgressView.set(backgroundColor: .red)
        self.alertProgressView.alpha = 1
        self.resetInputViews()
        self.alertProgressView.layer.removeAllAnimations()
        self.layer.borderColor = self.messageContext.color.color.cgColor
    }

    func resetInputViews() {
        self.textView.inputAccessoryView = nil
        self.textView.reloadInputViews()
    }

    private func showAlertConfirmation() {
        self.alertConfirmation.frame = CGRect(x: 0,
                                              y: 0,
                                              width: UIScreen.main.bounds.width,
                                              height: 60)
        self.alertConfirmation.keyboardAppearance = self.textView.keyboardAppearance
        self.textView.inputAccessoryView = self.alertConfirmation
        self.textView.reloadInputViews()

        ChannelManager.shared.activeChannel.value?.getMembersAsUsers()
            .observe(with: { (result) in
                switch result {
                case .success(let users):
                    self.alertConfirmation.setAlertMessage(for: users)
                case .failure(_):
                    break
                }
            })

        self.alertProgressView.size = CGSize(width: self.width, height: self.height)
    }
}

extension MessageInputView: GrowingTextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {}

    func textViewTextDidChange(_ textView: GrowingTextView) {
        guard let channel = ChannelManager.shared.activeChannel.value,
            self.textView.text.count > 0 else { return }
        // Twilio throttles this call to every 5 seconds
        channel.typing()
    }

    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: Theme.animationDuration) {
            self.textView.height = height
            self.height = height
            self.y = self.y + (self.oldTextViewHeight - height)
            self.layoutNow()
            self.oldTextViewHeight = height
        }
    }
}

extension MessageInputView: UIGestureRecognizerDelegate {

    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UILongPressGestureRecognizer {
            return self.textView.isFirstResponder
        }

        return true
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        if gestureRecognizer is UIPanGestureRecognizer {
            return false
        }
        
        return true
    }
}

private class AlertProgressView: View {}
