//
//  EmptyFeedView.swift
//  Benji
//
//  Created by Benji Dodgson on 6/30/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class EmptyFeedView: View {

    let label = MediumLabel()

    override func initializeSubviews() {
        super.initializeSubviews()
        
        self.addSubview(self.label)
        self.set(backgroundColor: .clear)
        self.addShadow(withOffset: 20)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if let text = self.label.attributedText {
            self.label.size = text.getSize(withWidth: self.proportionalWidth)
        }

        self.label.centerOnXAndY()
    }

    func set(text: Localized) {
        self.label.set(text: text, alignment: .center)
    }
}
