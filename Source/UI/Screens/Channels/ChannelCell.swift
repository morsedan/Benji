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

    let content = ChannelCellContentView()

    func configure(with item: ChannelsType?) {
        guard let type = item else { return }

        self.contentView.removeAllSubviews()
        self.contentView.addSubview(self.content)

        self.content.configure(with: type)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.content.frame = self.contentView.bounds
    }
}
