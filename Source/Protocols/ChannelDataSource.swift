//
//  ChannelDataSource.swift
//  Benji
//
//  Created by Benji Dodgson on 7/11/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import ReactiveSwift

protocol ChannelDataSource: AnyObject {

    var sections: [ChannelSectionType] { get set }
    var collectionView: CollectionView? { get set }

    func item(at indexPath: IndexPath) -> MessageType?
    func numberOfSections() -> Int
    func numberOfItems(inSection section: Int) -> Int

    func reset()
    func set(newSections: [ChannelSectionType])
    func append(item: MessageType)
    func update(item: MessageType, in section: Int)
    func delete(item: MessageType, in section: Int)
}

extension ChannelDataSource {

    func item(at indexPath: IndexPath) -> MessageType? {
        guard let section = self.sections[safe: indexPath.section],
            let item = section.items[safe: indexPath.row] else { return nil }

        return item
    }

    func numberOfSections() -> Int {
        return self.sections.count
    }

    func numberOfItems(inSection section: Int) -> Int {
        guard let section = self.sections[safe: section] else { return 0 }
        return section.items.count
    }

    func reset() {
        self.sections = []
        self.collectionView?.reloadData()
    }

    func set(newSections: [ChannelSectionType]) {
        self.sections = newSections
        self.collectionView?.reloadData()
    }

    func append(item: MessageType) {
        var sectionIndex: Int?
        var itemCount: Int?
        
        for (index, type) in self.sections.enumerated() {
            if type.date.isSameDay(as: item.createdAt) {
                sectionIndex = index
                itemCount = type.items.count
            }
        }

        if let count = itemCount, let section = sectionIndex {
            let indexPath = IndexPath(item: count, section: section)

            self.sections[section].items.append(item)
            self.collectionView?.insertItems(at: [indexPath])
        } else {
            //Create new section
            let newSection = ChannelSectionType(date: item.createdAt, items: [item])
            self.sections.append(newSection)
            self.collectionView?.reloadData()
        }
    }

    func updateLastItem(with item: MessageType) {

        if self.sections.count == 0 {
            self.append(item: item)
            return
        }

        guard let sectionValue = self.sections.last else { return }
        let section = self.sections.count - 1
        var indexPath: IndexPath?

        for (index, existingItem) in sectionValue.items.enumerated() {
            if localized(existingItem.body) == localized(item.body) {
                indexPath = IndexPath(item: index, section: section)
                break
            }
        }

        guard let ip = indexPath else { return }

        self.sections[section].items[ip.row] = item
        self.collectionView?.reloadItems(at: [ip])
    }

    func update(item: MessageType, in section: Int = 0) {
        guard let sectionValue = self.sections[safe: section] else { return }

        var indexPath: IndexPath?

        for (index, existingItem) in sectionValue.items.enumerated() {
            if existingItem == item {
                indexPath = IndexPath(item: index, section: section)
                break
            }
        }

        guard let ip = indexPath else { return }

        self.sections[section].items[ip.row] = item
        self.collectionView?.reloadItems(at: [ip])
    }

    func delete(item: MessageType, in section: Int = 0) {

        guard let sectionValue = self.sections[safe: section] else { return }

        var indexPath: IndexPath?

        for (index, existingItem) in sectionValue.items.enumerated() {
            if existingItem == item {
                indexPath = IndexPath(item: index, section: section)
                break
            }
        }

        guard let ip = indexPath else { return }

        self.sections[section].items.remove(at: ip.row)
        self.collectionView?.deleteItems(at: [ip])
    }
}
