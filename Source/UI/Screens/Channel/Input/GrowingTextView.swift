//
//  GrowingTextView.swift
//  Benji
//
//  Created by Benji Dodgson on 7/2/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

protocol GrowingTextViewDelegate: UITextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat)
    func textViewTextDidChange(_ textView: GrowingTextView)
}

class GrowingTextView: TextView {

    var currentHeight: CGFloat = 0

    // Customization
    var minHeight: CGFloat = 34 {
        didSet {
            self.resetLayout()
        }
    }

    var maxHeight: CGFloat = 200 {
        didSet {
            self.resetLayout()
        }
    }

    weak var growingDelegate: GrowingTextViewDelegate?

    private var shouldScrollAfterHeightChanged = true
    // Calculate and adjust textview's height
    private var oldText: String = ""
    private var oldSize: CGSize = .zero

    // Initialize
    override func initialize() {
        super.initialize()

        self.keyboardType = .twitter
        self.tintColor = Color.white.color
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: self.minHeight)
    }

    private func resetLayout() {
        self.oldSize = .zero
        self.layoutNow()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if self.text == self.oldText && self.size == self.oldSize { return }
        self.oldText = self.text
        self.oldSize = self.size

        let size = self.sizeThatFits(CGSize(width: self.bounds.size.width, height: CGFloat.greatestFiniteMagnitude))
        var height = size.height

        // Constrain minimum height
        height = self.minHeight > 0 ? max(height, self.minHeight) : height

        // Constrain maximum height
        height = self.maxHeight > 0 ? min(height, self.maxHeight) : height

        // Update height if needed
        if height != self.currentHeight {
            self.shouldScrollAfterHeightChanged = true
            self.currentHeight = height
            self.growingDelegate?.textViewDidChangeHeight(self, height: height)
        } else if self.shouldScrollAfterHeightChanged {
            self.shouldScrollAfterHeightChanged = false
            self.scrollToCorrectPosition()
        }
    }

    override func textDidChange(notification: Notification) {
        super.textDidChange(notification: notification)

        self.growingDelegate?.textViewTextDidChange(self)
    }
}

