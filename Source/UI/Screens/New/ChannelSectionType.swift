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

    var sectionType: Date
    var items: [MessageType] = []

    func diffIdentifier() -> NSObjectProtocol {
        return self.sectionType.diffIdentifier()
    }

    static func == (lhs: ChannelSectionType, rhs: ChannelSectionType) -> Bool {
        return lhs.sectionType == rhs.sectionType
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.sectionType)
    }
}
