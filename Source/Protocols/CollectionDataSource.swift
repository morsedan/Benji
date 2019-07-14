//
//  ChannelDataSource.swift
//  Benji
//
//  Created by Benji Dodgson on 7/11/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import ReactiveSwift

protocol CollectionDataSource: AnyObject {
    
    associatedtype SectionType: Hashable
    associatedtype ItemType: DisplayableCellItem
    associatedtype CollectionViewType: CollectionView

    var sections: MutableProperty<[SectionType: [ItemType]]> { get set }
    var sectionKeys: [SectionType] { get }

    func item(at indexPath: IndexPath, in collectionView: CollectionViewType) -> ItemType?
    func numberOfSections(in collectionView: CollectionViewType) -> Int
    func numberOfItems(inSection section: Int, in collectionView: CollectionViewType) -> Int
}

extension CollectionDataSource {

    var sectionKeys: [SectionType] {
        return Array(self.sections.value.keys)
    }

    func item(at indexPath: IndexPath, in collectionView: CollectionViewType) -> ItemType? {
        guard let key = self.sectionKeys[safe: indexPath.section],
            let values = self.sections.value[key],
            let value = values[safe: indexPath.row] else { return nil }

        return value
    }

    func numberOfSections(in collectionView: CollectionViewType) -> Int {
        return self.sectionKeys.count
    }

    func numberOfItems(inSection section: Int, in collectionView: CollectionViewType) -> Int {
        guard let key = self.sectionKeys[safe: section], let values = self.sections.value[key] else { return 0 }
        return values.count
    }
}
