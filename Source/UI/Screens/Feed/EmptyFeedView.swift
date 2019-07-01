//
//  EmptyFeedView.swift
//  Benji
//
//  Created by Benji Dodgson on 6/30/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class EmptyFeedView: View {

    let label = Label()

    var text: Localized? {
        didSet {
            guard let text = self.text else { return }

            let attributed = AttributedString(text,
                                              fontType: .medium,
                                              color: .white,
                                              kern: 0)
            self.label.set(attributed: attributed,
                           alignment: .center)
            self.layoutNow()
        }
    }

    override func initializeViews() {
        super.initializeViews()

        self.addSubview(self.label)
        self.set(backgroundColor: .clear)
        self.addShadow(withOffset: 20)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if let text = self.label.attributedText {
            self.label.size = text.getSize(withWidth: self.width * 0.8)
        }

        self.label.centerOnXAndY()
    }
}
