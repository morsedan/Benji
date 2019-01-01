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
    var oldTextViewHeight: CGFloat = 34

    override func initializeViews() {
        super.initializeViews()

        self.addSubview(self.darkEffectView)
        self.darkEffectView.autoPinEdgesToSuperviewEdges()

        self.addSubview(self.lightEffectView)
        self.addSubview(self.textView)

        let styleAttributes = StringStyle(font: .ultraLight, size: 18, color: .lightGray, kern: 0).attributes
        let string = NSAttributedString(string: "Message @Natalie", attributes: styleAttributes)
        self.textView.attributedPlaceholder = string
        self.textView.growingDelegate = self
        self.textView.height = 34
        self.lightEffectView.height = 34
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.addShadow(withOffset: -10)

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
        //Update the height

        UIView.animate(withDuration: Theme.animationDuration) {
            self.lightEffectView.height = height
            self.height = height + 36
            self.y = self.y + (self.oldTextViewHeight - height)
            self.layoutNow()
            self.oldTextViewHeight = height
        }
    }
}

protocol GrowingTextViewDelegate: UITextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat)
}

class GrowingTextView: TextView {

    override open var text: String! {
        didSet {
            self.setNeedsDisplay()
        }
    }
    private var heightConstraint: NSLayoutConstraint?

    // Maximum length of text. 0 means no limit.
    var maxLength: Int = 250

    // Trim white space and newline characters when end editing. Default is true
    var trimWhiteSpaceWhenEndEditing: Bool = true

    // Customization
    var minHeight: CGFloat = 0 {
        didSet {
            self.resetLayout()
        }
    }

    var maxHeight: CGFloat = 0 {
        didSet {
            self.resetLayout()
        }
    }

    var attributedPlaceholder: NSAttributedString? {
        didSet {
            self.setNeedsDisplay()
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
        let typingStyle = StringStyle(font: .regular, size: 18, color: .lightGray, kern: 0)
        self.typingAttributes = typingStyle.attributes
        self.contentMode = .redraw

        self.keyboardAppearance = .dark
        self.keyboardType = .twitter

        self.tintColor = Color.blue.color
        self.associateConstraints()
        self.maxHeight = 200
        self.minHeight = 34

        self.textContainerInset.left = 5
        self.textContainerInset.right = 5
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 34)
    }

    private func associateConstraints() {
        // iterate through all text view's constraints and identify
        // height,from: https://github.com/legranddamien/MBAutoGrowingTextView
        for constraint in self.constraints {
            if (constraint.firstAttribute == .height) {
                if (constraint.relation == .equal) {
                    self.heightConstraint = constraint;
                }
            }
        }
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

        let size = self.sizeThatFits(CGSize(width: bounds.size.width, height: CGFloat.greatestFiniteMagnitude))
        var height = size.height

        // Constrain minimum height
        height = self.minHeight > 0 ? max(height, self.minHeight) : height

        // Constrain maximum height
        height = self.maxHeight > 0 ? min(height, self.maxHeight) : height

        // Add height constraint if it is not found
        if self.heightConstraint == nil {
            self.heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height)
            addConstraint(self.heightConstraint!)
        }

        // Update height constraint if needed
        if height != self.heightConstraint!.constant {
            self.shouldScrollAfterHeightChanged = true
            self.heightConstraint!.constant = height
            self.growingDelegate?.textViewDidChangeHeight(self, height: height)
        } else if self.shouldScrollAfterHeightChanged {
            self.shouldScrollAfterHeightChanged = false
            self.scrollToCorrectPosition()
        }
    }

    private func scrollToCorrectPosition() {
        if self.isFirstResponder {
            self.scrollRangeToVisible(NSMakeRange(-1, 0)) // Scroll to bottom
        } else {
            self.scrollRangeToVisible(NSMakeRange(0, 0)) // Scroll to top
        }
    }

    // Show placeholder if needed
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        if self.text.isEmpty {
            let xValue = self.textContainerInset.left + self.textContainer.lineFragmentPadding
            let yValue = self.textContainerInset.top
            let width = rect.size.width - xValue - self.textContainerInset.right
            let height = rect.size.height - yValue - self.textContainerInset.bottom
            let placeholderRect = CGRect(x: xValue, y: yValue, width: width, height: height)

            if let attributedPlaceholder = self.attributedPlaceholder {
                // Prefer to use attributedPlaceholder
                attributedPlaceholder.draw(in: placeholderRect)
            }
        }
    }

    // Trim white space and new line characters when end editing.
    override func textDidEndEditing(notification: Notification) {
        if let sender = notification.object as? GrowingTextView, sender == self {
            if self.trimWhiteSpaceWhenEndEditing {
                self.text = self.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                self.setNeedsDisplay()
            }
            self.scrollToCorrectPosition()
        }
    }

    // Limit the length of text
    override func textDidChange(notification: Notification) {
        if let sender = notification.object as? GrowingTextView, sender == self {
            if self.maxLength > 0 && self.text.count > maxLength {
                let endIndex = self.text.index(self.text.startIndex, offsetBy: maxLength)
                self.text = String(self.text[..<endIndex])
                self.undoManager?.removeAllActions()
            }
            self.setNeedsDisplay()
        }
    }
}
