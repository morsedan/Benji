//
//  FeedCollectionView.swift
//  Benji
//
//  Created by Benji Dodgson on 6/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class FeedCollectionView: CollectionView {

    init() {
        let flowLayout = UICollectionViewFlowLayout()
        super.init(flowLayout: flowLayout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
