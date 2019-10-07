//
//  MessageInputView.swift
//  Benji
//
//  Created by Benji Dodgson on 8/17/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class MessageInputView: View, UIGestureRecognizerDelegate {

    let minHeight: CGFloat = 38

    let textView = InputTextView()
    let overlayButton = UIButton()
    let alertProgressView = UIView()
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))

    override func initializeSubviews() {
        super.initializeSubviews()

        self.set(backgroundColor: .backgroundWithAlpha)

        self.addSubview(self.blurView)
        self.addSubview(self.alertProgressView)
        self.alertProgressView.set(backgroundColor: .red)
        self.alertProgressView.size = .zero 
        self.addSubview(self.textView)
        self.textView.minHeight = self.minHeight
        self.addSubview(self.overlayButton)

        self.overlayButton.onTap { [unowned self] (tap) in
            if !self.textView.isFirstResponder {
                self.textView.becomeFirstResponder()
            }
        }

        self.layer.masksToBounds = true
        self.layer.borderColor = Color.lightPurple.color.cgColor
        self.layer.borderWidth = Theme.borderWidth
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
        self.layer.cornerRadius = Theme.cornerRadius
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let textViewWidth = self.width
        self.textView.size = CGSize(width: textViewWidth, height: self.textView.currentHeight)
        self.textView.left = 0
        self.textView.top = 0

        self.overlayButton.frame = self.bounds
        self.blurView.frame = self.bounds
    }
}
