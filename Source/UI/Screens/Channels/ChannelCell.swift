//
//  ChannelCell.swift
//  Benji
//
//  Created by Benji Dodgson on 2/3/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient

class ChannelCell: UICollectionViewCell, DisplayableCell {
    typealias ItemType = ChannelsType
    let label = Label()

    var localizedText: Localized? {
        didSet {
            guard let text = self.localizedText else { return }
            let attributed = AttributedString(text,
                                              size: 20,
                                              color: .darkGray)
            self.label.set(attributed: attributed)
        }
    }

    func configure(with item: ChannelsType?) {

        self.contentView.addSubview(self.label)
        self.label.autoPinEdgesToSuperviewEdges()

        guard let type = item else {
            self.configureAddChannel()
            return
        }

        switch type {
        case .system(let message):
            self.localizedText = message.body
        case .channel(let channel):
            self.localizedText = channel.friendlyName
        }

    }

    private func configureAddChannel() {
        self.localizedText = "Create New Channel"
    }
}
