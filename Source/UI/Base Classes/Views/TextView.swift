//
//  TextView.swift
//  Benji
//
//  Created by Benji Dodgson on 12/25/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

class TextView: UITextView {

    private var attributedPlaceholder: NSAttributedString? {
        didSet {
            self.setNeedsDisplay()
        }
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.initialize()
    }

    convenience init() {
        self.init(frame: CGRect.zero, textContainer: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(frame: .zero, textContainer: nil)
        self.initialize()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func initialize() {
        self.set(backgroundColor: .clear)

        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidEndEditing), name: UITextView.textDidEndEditingNotification, object: self)
    }

    func set(placeholder: Localized, color: Color = .lightPurple) {
        let styleAttributes = StringStyle(font: .regular, color: color).attributes
        let string = NSAttributedString(string: localized(placeholder), attributes: styleAttributes)
        self.attributedPlaceholder = string
    }

    func set(attributed: AttributedString,
             alignment: NSTextAlignment = .left,
             lineCount: Int = 0,
             lineBreakMode: NSLineBreakMode = .byWordWrapping,
             stringCasing: StringCasing = .unchanged,
             isEditable: Bool = false,
             linkColor: Color = .white) {

        let string = stringCasing.format(string: attributed.string.string)
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttributes(attributed.attributes, range: NSRange(location: 0,
                                                                             length: attributedString.length))

        attributedString.linkItems()
        self.linkTextAttributes = [.foregroundColor: linkColor.color, .underlineStyle: 1]

        self.isEditable = isEditable
        self.attributedText = attributedString
        self.textContainer.maximumNumberOfLines = lineCount
        self.textContainer.lineBreakMode = lineBreakMode
        self.textAlignment = alignment
        self.isUserInteractionEnabled = true
        self.dataDetectorTypes = .all
        self.textContainerInset = .zero
        self.textContainer.lineFragmentPadding = 0
    }

    @objc func textDidEndEditing(notification: Notification) {}
    @objc func textDidChange(notification: Notification) {}

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
}
