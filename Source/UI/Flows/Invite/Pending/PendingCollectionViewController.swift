//
//  PendingInviteViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 2/8/20.
//  Copyright © 2020 Benjamin Dodgson. All rights reserved.
//

import Foundation

class PendingCollectionViewController: CollectionViewController<InviteCell, PendingCollectionViewManager>, Sizeable  {

    init() {
        let collectionView = PendingCollectionView()
        super.init(with: collectionView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
