//
//  ContactsCollectionViewManager.swift
//  Benji
//
//  Created by Benji Dodgson on 6/30/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ContactsCollectionViewManager: CollectionViewManager<ContactCell> {

    override func managerDidConfigure(cell: ContactCell, for indexPath: IndexPath) {
        super.managerDidConfigure(cell: cell, for: indexPath)

        cell.button.onTap { [unowned self] (tap) in
            // handle the tap
            self.select(indexPath: indexPath)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.width, height: 90)
    }
}
