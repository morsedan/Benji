//
//  CollectionViewManager.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

protocol DisplayableCell {
    static var reuseID: String { get }
    var contentViewColor: Color { get }
    var didSelect: (IndexPath) -> Void { get set }
    var indexPath: IndexPath { get set }
    mutating func configure(with item: DisplayableItem, indexPath: IndexPath)
}

extension DisplayableCell where Self: UICollectionViewCell {

    static var reuseID: String {
        return String(describing: self)
    }

    mutating func configure(with item: DisplayableItem,
                   indexPath: IndexPath) {

        self.contentView.set(backgroundColor: self.contentViewColor)
        self.indexPath = indexPath
    }
}

class ItemCollectionViewManager<ItemType: DisplayableItem, CellType: DisplayableCell & UICollectionViewCell>: NSObject, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {

    var collectionView: UICollectionView?
    weak var delegate: AnyCollectionViewManagerDelegate<ItemType>?
    var cellModels: [ItemType] {
        didSet {
            self.collectionView?.reloadData()
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
                       indexPath: indexPath,
                       backgroundColor: CellType.backgroundColor)

        cell.didSelect = { [weak self] indexPath in
            guard let `self` = self else { return }
            let item = self.cellModels[indexPath.row]
            self.delegate?.collectionViewManager(didSelect: item, atIndexPath: indexPath)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: (collectionView.width-40)*0.333, height: (collectionView.height-80)*0.333)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets.init(top: 20, left: 20, bottom: 0, right: 20)
    }
}

//extension ItemCollectionViewManager: NewItemSelectionDelegate {
//
//    func newItemCell(_ cell: NewItemSelectionCell, didSelect indexPath: IndexPath) {
//    }
//}
