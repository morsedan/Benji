//
//  NewChannelCollectionViewLayout.swift
//  Benji
//
//  Created by Benji Dodgson on 8/27/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class FavoritesCollectionViewLayout: UICollectionViewFlowLayout {

    override func prepare() {
        super.prepare()

        self.scrollDirection = .horizontal

        self.collectionView?.contentInset.left = 10
        self.collectionView?.contentInset.right = 10
        self.collectionView?.contentInset.bottom = 10
        self.collectionView?.contentInset.top = 10
    }
}
