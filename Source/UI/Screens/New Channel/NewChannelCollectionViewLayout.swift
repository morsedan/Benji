//
//  NewChannelCollectionViewLayout.swift
//  Benji
//
//  Created by Benji Dodgson on 8/27/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class NewChannelCollectionViewLayout: UICollectionViewFlowLayout {

    override func prepare() {
        super.prepare()

        self.collectionView?.contentInset.left = 20
        self.collectionView?.contentInset.right = 20
        self.collectionView?.contentInset.bottom = 80
        self.collectionView?.contentInset.top = 10
    }
}
