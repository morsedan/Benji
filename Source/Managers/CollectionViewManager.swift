//
//  CollectionViewManager.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

class CollectionViewManager<ItemType: DisplayableCellItem & Diffable, CellType: DisplayableCell & UICollectionViewCell>: NSObject, UICollectionViewDataSource {

    var collectionView: UICollectionView
    weak var delegate: AnyCollectionViewManagerDelegate<ItemType>?
    var cellModels: [ItemType] {
        didSet {
            self.collectionView.reload(previousItems: oldValue,
                                       newItems: self.cellModels,
                                       equalityOption: IGListDiffOption.equality)
        }
    }

    init(withCollectionView collectionView: UICollectionView,
         models: [ItemType]) {

        self.cellModels = models
        collectionView.register(CellType.self, forCellWithReuseIdentifier: CellType.reuseID)
        self.collectionView = collectionView

        super.init()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.backgroundView?.isHidden = self.cellModels.count > 0
        return self.cellModels.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        var cell: CellType = collectionView.dequeueReusableCell(
            withReuseIdentifier: CellType.reuseID,
            for: indexPath) as! CellType

        let item = self.cellModels[indexPath.row]
        cell.configure(with: item,
                       indexPath: indexPath)

        cell.didSelect = { [weak self] indexPath in
            guard let `self` = self else { return }
            let item = self.cellModels[indexPath.row]
            self.delegate?.collectionViewManager(didSelect: item, atIndexPath: indexPath)
        }

        return cell
    }
}
