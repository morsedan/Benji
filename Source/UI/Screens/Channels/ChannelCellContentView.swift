//
//  ChannelCellContentView.swift
//  Benji
//
//  Created by Benji Dodgson on 6/29/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ChannelCellContentView: View {

    private let contextLabel = Label()
    private let messageLabel = Label()
    private var avatarView: AvatarView?

    var contextText: Localized? {
        didSet {
            guard let text = self.contextText else { return }
            let attributed = AttributedString(text,
                                              color: .white)
            self.contextLabel.set(attributed: attributed)
        }
    }

    var messageText: Localized? {
        didSet {
            guard let text = self.messageText else { return }
            let attributed = AttributedString(text,
                                              color: .white)
            self.messageLabel.set(attributed: attributed)
        }
    }

    func configure(with type: ChannelsType) {

        switch type {
        case .system(let message):
            //self.localizedText = message.body
            break
        case .channel(let channel):
            //self.localizedText = channel.friendlyName
            break
        }
    }
}
