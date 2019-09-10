//
//  NewChannelCollectionViewManager.swift
//  Benji
//
//  Created by Benji Dodgson on 8/27/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import ReactiveSwift

class FavoritesCollectionViewManager: CollectionViewManager<FavoriteCell> {

    let selectedIndexes = MutableProperty<Set<IndexPath>>([])
    
    override func initialize() {
        super.initialize()

        self.selectedIndexes.producer.on { (selectedReferralIndexes) in
            let indexPaths = Array(selectedReferralIndexes)
            self.collectionView.reloadItems(at: indexPaths)
        }.start()
    }

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }

    override func managerWillDisplay(cell: FavoriteCell, for indexPath: IndexPath) -> FavoriteCell {
        let isChecked = self.selectedIndexes.value.contains(indexPath)
        cell.set(isChecked: isChecked)
        return cell
    }

    func updateRows(with selectedIndexPath: IndexPath) {
        if self.selectedIndexes.value.contains(selectedIndexPath) {
            self.selectedIndexes.modify { (indexes) in
                return indexes.remove(selectedIndexPath)
            }
        } else {
            self.selectedIndexes.modify { (indexes) in
                return indexes.insert(selectedIndexPath)
            }
        }
    }
}
