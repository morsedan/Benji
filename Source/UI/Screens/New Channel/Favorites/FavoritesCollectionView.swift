//
//  NewChannelCollectionView.swift
//  Benji
//
//  Created by Benji Dodgson on 8/27/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class FavoritesCollectionView: CollectionView {

    init() {
        let flowLayout = FavoritesCollectionViewLayout()
        super.init(flowLayout: flowLayout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initialize() {
        super.initialize()

        self.register(ContextCell.self)
        self.register(FavoriteCell.self)
        self.register(NewContextCell.self)
        self.register(NewFavoriteCell.self)
        self.register(FavoritesSectionHeader.self,
                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
    }
    
}
