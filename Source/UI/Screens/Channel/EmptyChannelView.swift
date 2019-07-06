//
//  EmptyChannelView.swift
//  Benji
//
//  Created by Benji Dodgson on 7/6/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class EmptyChannelView: View {

    let titleLabel = Label()
    let descriptionLabel = Label()
    let actionLabel = Label()

    var titleText: Localized? {
        didSet {
            guard let text = self.titleText else { return }

            let attributed = AttributedString(text,
                                              fontType: .display1,
                                              color: .white,
                                              kern: 0)
            self.titleLabel.set(attributed: attributed,
                                alignment: .center)
        }
    }

    var descriptionText: Localized? {
        didSet {
            guard let text = self.descriptionText else { return }

            let attributed = AttributedString(text,
                                              fontType: .small,
                                              color: .white,
                                              kern: 0)
            self.descriptionLabel.set(attributed: attributed,
                                      alignment: .center)
        }
    }

    var actionText: Localized? {
        didSet {
            guard let text = self.actionText else { return }

            let attributed = AttributedString(text,
                                              fontType: .regular,
                                              color: .white,
                                              kern: 0)
            self.actionLabel.set(attributed: attributed,
                                 alignment: .center)
        }
    }

    override func initialize() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.descriptionLabel)
        self.addSubview(self.actionLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.tt
    }
}
