//
//  CollectionViewManager.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation
import ReactiveSwift
import GestureRecognizerClosures

class CollectionViewManager<CellType: ManageableCell & UICollectionViewCell>: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    unowned let collectionView: UICollectionView

    var items = MutableProperty<[CellType.ItemType]>([])

    // MARK: Selection
    var allowMultipleSelection: Bool = false
    private(set) var selectedIndexPaths: Set<IndexPath> = [] {
        didSet {
            self.updateSelected(indexPaths: self.selectedIndexPaths, and: oldValue)
        }
    }
    var selectedItems: [CellType.ItemType] {
        var items: [CellType.ItemType] = []
        for indexPath in self.selectedIndexPaths {
            if let item = self.items.value[safe: indexPath.row] {
                items.append(item)
            }
        }
        return items
    }

    // MARK: Events

     lazy var onSelectedItem = Property(self._onSelectedItem)
     private let _onSelectedItem = MutableProperty<(item: CellType.ItemType, indexPath: IndexPath)?>(nil)
     var didLongPress: ((CellType.ItemType, IndexPath) -> Void)?
     var willDisplayCell: ((CellType.ItemType, IndexPath) -> Void)?

    var didSelect: (_ item: CellType.ItemType, _ indexPath: IndexPath) -> Void = { _, _ in }

    required init(with collectionView: UICollectionView) {

        self.collectionView = collectionView
        super.init()
        self.initializeCollectionView()
    }

    func initializeCollectionView() {
        self.collectionView.register(CellType.self, forCellWithReuseIdentifier: CellType.reuseID)
    }

    private func updateSelected(indexPaths: Set<IndexPath>, and oldIndexPaths: Set<IndexPath>) {
        // Reset all the old indexPaths if they are not also in the new array
        oldIndexPaths.forEach { (indexPath) in
            if !indexPaths.contains(indexPath),
                let cell = self.collectionView.cellForItem(at: indexPath) as? CellType {
                cell.update(isSelected: self.allowMultipleSelection)
            }
        }

        indexPaths.forEach { (indexPath) in
            if let cell = self.collectionView.cellForItem(at: indexPath) as? CellType {
                cell.update(isSelected: true)
            }
        }
    }

    func reset() {
        self.items.value = []
        self.collectionView.reloadData()
    }

    func set(newItems: [CellType.ItemType], completion: ((Bool) -> Swift.Void)? = nil) {
        self.updateCollectionView(items: newItems, modify: { [weak self] in
            guard let `self` = self else { return }
            self.items.value = newItems
        }, completion: completion)
    }

    func append(item: CellType.ItemType, in section: Int = 0) {

        guard self.items.value.count > 0 else {
            self.set(newItems: [item])
            return
        }

        guard !self.items.value.contains(item) else { return }

        let indexPath = IndexPath(item: self.items.value.count, section: section)
        self.items.value.append(item)
        self.collectionView.insertItems(at: [indexPath])
    }

    func update(item: CellType.ItemType, in section: Int = 0) {
        var indexPath: IndexPath?
        for (index, existingItem) in self.items.value.enumerated() {
            if existingItem == item {
                indexPath = IndexPath(item: index, section: section)
                break
            }
        }

        guard let ip = indexPath else { return }

        self.items.value[ip.item] = item
        self.collectionView.reloadItems(at: [ip])
    }

    func delete(item: CellType.ItemType, in section: Int = 0) {

        var indexPath: IndexPath?
        for (index, existingItem) in self.items.value.enumerated() {
            if existingItem == item {
                indexPath = IndexPath(item: index, section: section)
                break
            }
        }

        guard let ip = indexPath else { return }

        self.items.value.remove(at: ip.item)
        self.collectionView.deleteItems(at: [ip])
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.backgroundView?.isHidden = self.items.value.count > 0
        return self.items.value.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell: CellType = collectionView.dequeueReusableCell(withReuseIdentifier: CellType.reuseID,
                                                                for: indexPath) as! CellType

        let item = self.items.value[safe: indexPath.row]
        cell.configure(with: item)
        //Reset all gestures
        cell.contentView.gestureRecognizers?.forEach({ (recognizer) in
            cell.contentView.removeGestureRecognizer(recognizer)
        })

        cell.contentView.onTap { [weak self] (tap) in
            guard let `self` = self, let item = self.items.value[safe: indexPath.row] else { return }
            self.didSelect(item, indexPath)
        }

        cell.contentView.onLongPress { [weak self] (longPress) in
            guard let `self` = self, let item = self.items.value[safe: indexPath.row] else { return }
            self.didLongPress?(item, indexPath)
        }

        self.managerWillDisplay(cell: cell, for: indexPath)
        return cell
    }

    func managerWillDisplay(cell: CellType, for indexPath: IndexPath) { }

    private func updateCollectionView(items: [CellType.ItemType],
                                      modify: @escaping () -> Void,
                                      completion: ((Bool) -> Swift.Void)? = nil) {

        self.reloadCollectionView(previousItems: self.items.value,
                                  newItems: items,
                                  modify: modify,
                                  completion: completion)
    }

    private func reloadCollectionView(previousItems: [CellType.ItemType],
                                      newItems: [CellType.ItemType],
                                      modify: @escaping () -> Void,
                                      completion: ((Bool) -> Swift.Void)? = nil) {

        self.collectionView.reload(previousItems: previousItems,
                                   newItems: newItems,
                                   equalityOption: .equality,
                                   modify: modify,
                                   completion: completion)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.width, height: 100)
    }
}
