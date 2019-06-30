//
//  HomeStackViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 6/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class FeedViewController: CollectionViewController<FeedCell, FeedCollectionViewManager> {

    init() {
        let collectionView = FeedCollectionView()
        super.init(with: collectionView)
        self.view.set(backgroundColor: .background1)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
