//
//  PreviewMessageView.swift
//  Benji
//
//  Created by Benji Dodgson on 8/24/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class PreviewMessageView: View {

    let minHeight: CGFloat = 52
    let textView = InputTextView()
    let backgroundView = View()

    override func initialize() {
        super.initialize()

        self.addSubview(self.backgroundView)
        self.backgroundView.set(backgroundColor: .lightPurple)
        self.addSubview(self.textView)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.minHeight * 0.5
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.backgroundView.frame = self.bounds

        let textViewWidth = self.width - 20
        self.textView.size = CGSize(width: textViewWidth, height: self.height)
        self.textView.left = 10
        self.textView.top = 0
    }
}
