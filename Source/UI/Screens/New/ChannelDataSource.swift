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

class ChannelSectionType: DiffableSection {
    typealias SectionType = Date
    typealias ItemType = MessageType

    var sectionType: Date
    var items: [MessageType] = []

    init(with sectionType: Date, items: [MessageType] = []) {
        self.sectionType = sectionType
        self.items = items
    }

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

class ChannelDataSource: CollectionViewDataSource {
    typealias SectionType = ChannelSectionType
    typealias CollectionViewType = ChannelCollectionView

    var sections: MutableProperty<[ChannelSectionType]> = MutableProperty([])
    var previousSections: [ChannelSectionType]?
    var collectionView: ChannelCollectionView

    init(with collectionView: ChannelCollectionView) {
        self.collectionView = collectionView
    }
}
