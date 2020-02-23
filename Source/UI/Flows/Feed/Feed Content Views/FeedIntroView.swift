//
//  FeedIntroView.swift
//  Benji
//
//  Created by Benji Dodgson on 12/7/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TMROLocalization

class FeedIntroView: View {

    private let label = FeedQuoteLabel()

    override func initializeSubviews() {
        super.initializeSubviews()

        self.addSubview(self.label)
        self.label.set(text: Lorem.quote())
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.label.setSize(withWidth: self.width * 0.9)
        self.label.centerOnXAndY()
    }
}

private class FeedQuoteLabel: Label {

    func set(text: Localized) {
        let attributed = AttributedString(text,
                                          fontType: .medium,
                                          color: .white)

        self.set(attributed: attributed,
                 alignment: .center,
                 stringCasing: .unchanged)
    }
}
