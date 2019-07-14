//
//  ChannelDataSource.swift
//  Benji
//
//  Created by Benji Dodgson on 7/11/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import ReactiveSwift

protocol CollectionDataSourceManager: AnyObject {
    
    associatedtype SectionType: Hashable
    associatedtype ItemType: DisplayableCellItem
    associatedtype CollectionViewType: CollectionView

    var sections: MutableProperty<[SectionType: [ItemType]]> { get set }
    var previousSections: [SectionType: [ItemType]]? { get set }
    var sectionKeys: [SectionType] { get }
    var collectionView: CollectionViewType { get set }

    func item(at indexPath: IndexPath, in collectionView: CollectionViewType) -> ItemType?
    func numberOfSections(in collectionView: CollectionViewType) -> Int
    func numberOfItems(inSection section: Int, in collectionView: CollectionViewType) -> Int

    func reset()
    func set(newSections: [SectionType: [ItemType]])
    func append(item: ItemType, in section: Int)
    func update(item: ItemType, in section: Int)
    func delete(item: ItemType, in section: Int)
}

extension CollectionDataSourceManager {

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

    func reset() {
        self.sections.value = [SectionType: [ItemType]]()
        self.previousSections = nil
        self.collectionView.reloadData()
    }

    func set(newSections: [SectionType: [ItemType]]) {
        self.updateCollectionView(sections: newSections, modify: { [weak self] in
            guard let `self` = self else { return }
            self.sections.value = newSections
        })
    }

    func append(item: ItemType, in section: Int = 0) {

        guard let key = self.sectionKeys[safe: section],
        let sectionValues = self.sections.value[key],
        !sectionValues.contains(item) else { return }

        let indexPath = IndexPath(item: sectionValues.count, section: section)

        self.sections.value[key]?.append(item)
        self.collectionView.insertItems(at: [indexPath])
    }

    func update(item: ItemType, in section: Int = 0) {
        guard let key = self.sectionKeys[safe: section],
            let sectionValues = self.sections.value[key] else { return }

        var indexPath: IndexPath?

        for (index, existingItem) in sectionValues.enumerated() {
            if existingItem == item {
                indexPath = IndexPath(item: index, section: section)
                break
            }
        }

        guard let ip = indexPath else { return }

        self.sections.value[key]?[ip.row] = item
        self.collectionView.reloadItems(at: [ip])
    }

    func delete(item: ItemType, in section: Int = 0) {

        guard let key = self.sectionKeys[safe: section],
            let sectionValues = self.sections.value[key] else { return }

        var indexPath: IndexPath?

        for (index, existingItem) in sectionValues.enumerated() {
            if existingItem == item {
                indexPath = IndexPath(item: index, section: section)
                break
            }
        }

        guard let ip = indexPath else { return }

        self.sections.value[key]?.remove(at: ip.row)
        self.collectionView.deleteItems(at: [ip])
    }

    private func updateCollectionView(sections: [SectionType: [ItemType]],
                                      modify: @escaping () -> Void) {

        let previous = self.previousSections ?? [SectionType: [ItemType]]()
        self.reloadCollectionView(previousSections: previous,
                                  newSections: sections,
                                  modify: modify)

        self.previousSections = sections
    }

    private func reloadCollectionView(previousSections: [SectionType: [ItemType]],
                                      newSections: [SectionType: [ItemType]],
                                      modify: @escaping () -> Void) {

        self.collectionView.reload(previousItems: <#T##[Diffable]#>, newItems: <#T##[Diffable]#>, equalityOption: <#T##IGListDiffOption#>, modify: <#T##() -> Void#>)
        self.collectionView.reload(previousItems: previousSections,
                                   newItems: newSections,
                                   equalityOption: .equality,
                                   modify: modify,
                                   completion: nil)
    }
}
