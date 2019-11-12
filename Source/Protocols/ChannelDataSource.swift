//
//  ChannelDataSource.swift
//  Benji
//
//  Created by Benji Dodgson on 7/11/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TMROLocalization

typealias CompletionOptional = (() -> Void)?

protocol ChannelDataSource: AnyObject {

    var sections: [ChannelSectionable] { get set }
    var collectionView: ChannelCollectionView { get set }

    func item(at indexPath: IndexPath) -> Messageable?
    func numberOfSections() -> Int
    func numberOfItems(inSection section: Int) -> Int

    func reset()
    func set(newSections: [ChannelSectionable],
             keepOffset: Bool,
             completion: CompletionOptional)
    func append(item: Messageable, completion: CompletionOptional)
    func update(item: Messageable, in section: Int)
    func delete(item: Messageable, in section: Int)
}

extension ChannelDataSource {

    func item(at indexPath: IndexPath) -> Messageable? {
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
        self.collectionView.reloadData()
    }

    func set(newSections: [ChannelSectionable],
             keepOffset: Bool = false,
             completion: CompletionOptional) {

        guard newSections.count > 0 else {
            completion?()
            return
        }

        self.sections = newSections

        if keepOffset {
            self.collectionView.reloadDataAndKeepOffset()
            completion?()
        } else {
            self.collectionView.reloadData()
            completion?()
        }
    }

    func append(item: Messageable, completion: CompletionOptional) {
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

            self.collectionView.performBatchUpdates(modifyItems: { [unowned self] in
                self.sections[section].items.append(item)
                }, updates: { [unowned self] in
                    self.collectionView.insertItems(at: [indexPath])
            }) { (completed) in
                completion?()
            }

        } else {
            //Create new section
            let new = ChannelSectionable(date: item.createdAt, items: [item])
            self.sections.append(new)
            self.collectionView.reloadData()
            completion?()
        }
    }

    func updateLastItem(with item: Messageable,
                        replaceTypingIndicator: Bool = false,
                        completion: CompletionOptional) {

        if self.sections.count == 0 {
            self.append(item: item, completion: completion)
            return
        }

        guard let sectionValue = self.sections.last else { return }
        let section = self.sections.count - 1
        var indexPath: IndexPath?

        for (index, existingItem) in sectionValue.items.enumerated() {
            if localized(existingItem.text) == localized(item.text) {
                indexPath = IndexPath(item: index, section: section)
                break
            }
        }

        if indexPath == nil {
            if replaceTypingIndicator {
                indexPath = IndexPath(item: sectionValue.items.count - 1, section: section)
            } else {
                self.append(item: item, completion: completion)
            }
        }

        guard let ip = indexPath else { return }

        self.collectionView.performBatchUpdates(modifyItems: {
            self.sections[section].items[ip.row] = item
        }, updates: {
            self.collectionView.reloadItems(at: [ip])
        }) { (completed) in
            completion?()
        }
    }

    func update(item: Messageable, in section: Int = 0) {
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
        self.collectionView.reloadItems(at: [ip])
    }

    func delete(item: Messageable, in section: Int = 0) {

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
        self.collectionView.deleteItems(at: [ip])
    }
}
