//
//  CollectionViewManager.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation
import ReactiveSwift

class CollectionViewManager<ItemType: DisplayableCellItem & Diffable, CellType: DisplayableCell & UICollectionViewCell>: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var collectionView: UICollectionView
    weak var delegate: AnyCollectionViewManagerDelegate<ItemType>?

    let items = MutableProperty<[ItemType]>([])
    // A deep copied array representing the last state of the items.
    // Used to animate changes to the collection view
    private var previousItems: [ItemType]?

    init(with collectionView: UICollectionView,
         items: [ItemType]) {

        self.items.value = items
        collectionView.register(CellType.self, forCellWithReuseIdentifier: CellType.reuseID)
        self.collectionView = collectionView

        super.init()

        self.items.producer.on { [unowned self] (items) in
            self.updateCollectionView(items: items)
        }.start()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.backgroundView?.isHidden = self.items.value.count > 0
        return self.items.value.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        var cell: CellType = collectionView.dequeueReusableCell(
            withReuseIdentifier: CellType.reuseID,
            for: indexPath) as! CellType

        if let item = self.items.value[safe: indexPath.row] {
            cell.configure(with: item,
                           indexPath: indexPath)
        }

        cell.didSelect = { [weak self] indexPath in
            guard let `self` = self, let item = self.items.value[safe: indexPath.row] else { return }
            self.delegate?.collectionViewManager(didSelect: item, at: indexPath)
        }

        return cell
    }

    private func updateCollectionView(items: [ItemType]) {

        if self.previousItems == nil {
            self.previousItems = items
        }

        self.reloadCollectionView(previousItems: self.previousItems ?? [], newItems: items)

        self.previousItems = items
    }

    private func reloadCollectionView(previousItems: [ItemType], newItems: [ItemType]) {
        self.collectionView.reload(previousItems: previousItems,
                                   newItems: newItems,
                                   equalityOption: IGListDiffOption.equality)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .zero 
    }
}
