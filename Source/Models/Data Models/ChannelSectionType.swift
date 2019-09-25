//
//  ChannelDataSource.swift
//  Benji
//
//  Created by Benji Dodgson on 7/14/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import ReactiveSwift

class ChannelSectionType {

    var date: Date
    var items: [MessageType] = []
    var channelType: ChannelType?

    var firstMessageIndex: Int? {
        guard let firstType = self.items.first else { return nil }

        switch firstType {
        case .message(let message):
            return message.index?.intValue
        default:
            return nil
        }
    }

    init(date: Date,
         items: [MessageType],
         channelType: ChannelType? = nil) {

        self.date = date
        self.items = items
        self.channelType = channelType
    }
}
