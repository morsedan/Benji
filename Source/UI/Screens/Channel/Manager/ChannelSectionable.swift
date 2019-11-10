//
//  ChannelSectionable.swift
//  Benji
//
//  Created by Benji Dodgson on 11/9/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ChannelSectionable {

    var date: Date
    var items: [Messageable] = []
    var channelType: ChannelType?

    init(date: Date,
         items: [Messageable],
         channelType: ChannelType? = nil) {

        self.date = date
        self.items = items
        self.channelType = channelType
    }
}
