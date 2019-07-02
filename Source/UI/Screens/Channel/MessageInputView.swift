//
//  MessageInputView.swift
//  Benji
//
//  Created by Benji Dodgson on 12/29/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

class MessageInputView: View, UITextViewDelegate {

    let textView = GrowingTextView()
    let darkEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let lightEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    var oldTextViewHeight: CGFloat = 48

    override func initializeViews() {
        super.initializeViews()

        self.addSubview(self.darkEffectView)
        self.darkEffectView.autoPinEdgesToSuperviewEdges()

        self.addSubview(self.lightEffectView)
        self.addSubview(self.textView)

        self.textView.growingDelegate = self
        self.textView.minHeight = 48
        self.lightEffectView.height = 48

        self.set(placeholder: "Message...")
    }

    func set(placeholder: Localized) {
        let styleAttributes = StringStyle(font: .regularSemiBold, color: .lightPurple, kern: 0).attributes
        let string = NSAttributedString(string: localized(placeholder), attributes: styleAttributes)
        self.textView.attributedPlaceholder = string
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.lightEffectView.width = self.width * 0.9
        self.lightEffectView.top = 10
        self.lightEffectView.centerOnX()
        self.lightEffectView.roundCorners()

        self.textView.frame = self.lightEffectView.frame
        self.darkEffectView.round(corners: [.topLeft, .topRight], size: CGSize(width: 10, height: 10))
    }
}

extension MessageInputView: GrowingTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: Theme.animationDuration) {
            self.lightEffectView.height = height
            self.height = height + 42
            self.y = self.y + (self.oldTextViewHeight - height)
            self.layoutNow()
            self.oldTextViewHeight = height
        }
    }
}
