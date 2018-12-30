//
//  MessageInputView.swift
//  Benji
//
//  Created by Benji Dodgson on 12/29/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

class MessageInputView: View {

    let textView = MessageInputTextView()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))

    override func initializeViews() {
        super.initializeViews()
        self.set(backgroundColor: .halfWhite)

        self.addSubview(self.effectView)
        self.effectView.autoPinEdgesToSuperviewEdges()

        self.addSubview(self.textView)
        self.textView.autoPinEdgesToSuperviewEdges()

        self.textView.localizedText = "Type something..."
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.halfHeight

        self.effectView.layer.masksToBounds = true
        self.effectView.layer.cornerRadius = self.halfHeight

        self.addShadow(withOffset: 5)
    }
}

class MessageInputTextView: TextView {

    var localizedText: Localized? {
        willSet {
            guard let text = newValue else { return }

            let attributedString = AttributedString(text,
                                                    font: .regular,
                                                    size: 18,
                                                    color: .white,
                                                    kern: 0)
            self.set(attributed: attributedString)
        }
    }

    override func initialize() {
        super.initialize()


    }
}
