//
//  ChannelDataSource.swift
//  Benji
//
//  Created by Benji Dodgson on 7/11/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import ReactiveSwift

protocol DiffableSection: AnyObject, Diffable {
    associatedtype SectionType: Diffable
    associatedtype ItemType: DisplayableCellItem

    var sectionType: SectionType { get set }
    var items: [ItemType] { get set }
}

protocol CollectionViewDataSource: AnyObject {
    
    associatedtype SectionType: DiffableSection
    associatedtype CollectionViewType: CollectionView

    var sections: MutableProperty<[SectionType]> { get set }
    var previousSections: [SectionType]? { get set }
    var collectionView: CollectionViewType { get set }

    func item(at indexPath: IndexPath, in collectionView: CollectionViewType) -> SectionType.ItemType?
    func numberOfSections(in collectionView: CollectionViewType) -> Int
    func numberOfItems(inSection section: Int, in collectionView: CollectionViewType) -> Int

    func reset()
    func set(newSections: [SectionType])
    func append(item: SectionType.ItemType, in section: Int)
    func update(item: SectionType.ItemType, in section: Int)
    func delete(item: SectionType.ItemType, in section: Int)
}

extension CollectionViewDataSource {

    func item(at indexPath: IndexPath, in collectionView: CollectionViewType) -> SectionType.ItemType? {
        guard let section = self.sections.value[safe: indexPath.section],
            let item = section.items[safe: indexPath.row] else { return nil }

        return item
    }

    func numberOfSections(in collectionView: CollectionViewType) -> Int {
        return self.sections.value.count
    }

    func numberOfItems(inSection section: Int, in collectionView: CollectionViewType) -> Int {
        guard let section = self.sections.value[safe: section] else { return 0 }
        return section.items.count
    }

    func reset() {
        self.sections.value = []
        self.previousSections = nil
        self.collectionView.reloadData()
    }

    func set(newSections: [SectionType]) {
        self.updateCollectionView(sections: newSections, modify: { [weak self] in
            guard let `self` = self else { return }
            self.sections.value = newSections
        })
    }

    func append(item: SectionType.ItemType, in section: Int = 0) {

        guard let sectionValue = self.sections.value[safe: section],
        !sectionValue.items.contains(item) else { return }

        let indexPath = IndexPath(item: sectionValue.items.count, section: section)

        self.sections.value[section].items.append(item)
        self.collectionView.insertItems(at: [indexPath])
    }

    func update(item: SectionType.ItemType, in section: Int = 0) {
        guard let sectionValue = self.sections.value[safe: section] else { return }

        var indexPath: IndexPath?

        for (index, existingItem) in sectionValue.items.enumerated() {
            if existingItem == item {
                indexPath = IndexPath(item: index, section: section)
                break
            }
        }

        guard let ip = indexPath else { return }

        self.sections.value[section].items[ip.row] = item
        self.collectionView.reloadItems(at: [ip])
    }

    func delete(item: SectionType.ItemType, in section: Int = 0) {

        guard let sectionValue = self.sections.value[safe: section] else { return }

        var indexPath: IndexPath?

        for (index, existingItem) in sectionValue.items.enumerated() {
            if existingItem == item {
                indexPath = IndexPath(item: index, section: section)
                break
            }
        }

        guard let ip = indexPath else { return }

        self.sections.value[section].items.remove(at: ip.row)
        self.collectionView.deleteItems(at: [ip])
    }

    private func updateCollectionView(sections: [SectionType], modify: @escaping () -> Void) {

        let previous = self.previousSections ?? []
        self.reloadCollectionView(previousSections: previous,
                                  newSections: sections,
                                  modify: modify)

        self.previousSections = sections
    }

    private func reloadCollectionView(previousSections: [SectionType],
                                      newSections: [SectionType],
                                      modify: @escaping () -> Void) {

        self.collectionView.reload(previousItems: previousSections,
                                   newItems: newSections,
                                   equalityOption: .equality,
                                   modify: modify,
                                   completion: nil)
    }
}
