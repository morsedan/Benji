//
//  FavoritesViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 9/8/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse 

class FavoritesViewController: CollectionViewController<FavoriteCell, FavoritesCollectionViewManager> {

    override func initializeViews() {
        super.initializeViews()

        guard let objectId = User.current()?.objectId else { return }

        User.cachedArrayQuery(notEqualTo: objectId)
            .observe { (result) in
                switch result {
                case .success(let users):
                    self.manager.set(newItems: users)
                case .failure(_):
                    break
                }
        }
    }
}
