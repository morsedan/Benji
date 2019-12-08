//
//  FeedRoutineView.swift
//  Benji
//
//  Created by Benji Dodgson on 12/7/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class FeedRoutineView: View {

    let textView = FeedTextView()
    let button = Button()

    override func initializeSubviews() {
        super.initializeSubviews()

        self.addSubview(self.textView)
        self.addSubview(self.button)
        self.textView.set(localizedText: "Set a time to check your feed.")
        self.button.set(style: .normal(color: .blue, text: "SET"))
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.textView.setSize(withWidth: self.width)
        self.textView.centerOnX()
        self.textView.top = 0

        self.button.size = CGSize(width: 100, height: 40)
        self.button.centerOnX()
        self.button.bottom = self.height
    }
}
