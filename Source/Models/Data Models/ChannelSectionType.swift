//
//  ChannelDataSource.swift
//  Benji
//
//  Created by Benji Dodgson on 7/14/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ChannelSectionType {

    var date: Date
    var items: [Messageable] = []
    var channelType: ChannelType?

    var firstMessageIndex: Int? {
        return self.items.first?.messageIndex?.intValue
    }

    init(date: Date,
         items: [Messageable],
         channelType: ChannelType? = nil) {

        self.date = date
        self.items = items
        self.channelType = channelType
    }
}
