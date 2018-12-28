//
//  CollectionViewManagerDelegate.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

protocol CollectionViewManagerDelegate: class {
    associatedtype ItemType

    func collectionViewManager(didSelect item: ItemType?, at indexPath: IndexPath)
}

class AnyCollectionViewManagerDelegate<Item>: CollectionViewManagerDelegate {

    private let didSelect: ((Item?, IndexPath) -> Void)

    required init<U: CollectionViewManagerDelegate>(_ collectionViewManagerDelegate: U)
        where U.ItemType == Item {
            self.didSelect = collectionViewManagerDelegate.collectionViewManager(didSelect:at:)
    }

    func collectionViewManager(didSelect item: Item?, at indexPath: IndexPath) {
        self.didSelect(item, indexPath)
    }
}
