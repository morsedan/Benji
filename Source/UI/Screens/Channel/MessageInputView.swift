//
//  MessageInputView.swift
//  Benji
//
//  Created by Benji Dodgson on 12/29/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

class MessageInputView: View, UITextViewDelegate {

    let textView = MessageInputTextView()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))

    override func initializeViews() {
        super.initializeViews()
        self.set(backgroundColor: .darkGray)

//        self.addSubview(self.effectView)
//        self.effectView.autoPinEdgesToSuperviewEdges()

        self.addSubview(self.textView)

        //self.textView.localizedText = "Message @Natalie"
        self.textView.delegate = self
        self.textView.height = 50

    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.addShadow(withOffset: -10)

        self.textView.width = self.width - 50
        self.textView.top = 10
        self.textView.left = 40

        self.textView.roundCorners()
        self.textView.layer.borderColor = Color.blue.color.cgColor
        self.textView.layer.borderWidth = 2
    }

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true 
    }
}

class MessageInputTextView: TextView {

    var localizedText: Localized? {
        willSet {
            guard let text = newValue else { return }

            let attributedString = AttributedString(text,
                                                    font: .regular,
                                                    size: 16,
                                                    color: .lightGray,
                                                    kern: 0)
            self.set(attributed: attributedString)
        }
    }

    init() {
        super.init(frame: .zero, textContainer: nil)
        self.initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initialize() {

        self.isEditable = true
        self.isUserInteractionEnabled = true
        self.keyboardAppearance = .dark
        self.isSelectable = true
        self.set(backgroundColor: .clear)
    }
}
