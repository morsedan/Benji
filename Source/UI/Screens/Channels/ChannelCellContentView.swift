//
//  ChannelCellContentView.swift
//  Benji
//
//  Created by Benji Dodgson on 6/29/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ChannelCellContentView: View {

    let label = Label()

    var localizedText: Localized? {
        didSet {
            guard let text = self.localizedText else { return }
            let attributed = AttributedString(text,
                                              color: .white)
            self.label.set(attributed: attributed)
        }
    }

    func configure(with type: ChannelsType) {

        switch type {
        case .system(let message):
            self.localizedText = message.body
        case .channel(let channel):
            self.localizedText = channel.friendlyName
        }
    }
}
