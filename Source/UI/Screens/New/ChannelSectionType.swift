//
//  ChannelDataSource.swift
//  Benji
//
//  Created by Benji Dodgson on 7/14/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import ReactiveSwift

extension Date: Diffable {
    func diffIdentifier() -> NSObjectProtocol {
        return String(self.hashValue) as NSObjectProtocol
    }
}

struct ChannelSectionType: Diffable {

    var date: Date
    var items: [MessageType] = []

    func diffIdentifier() -> NSObjectProtocol {
        return self.date.diffIdentifier()
    }

    static func == (lhs: ChannelSectionType, rhs: ChannelSectionType) -> Bool {
        return lhs.date == rhs.date
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.date)
    }
}
