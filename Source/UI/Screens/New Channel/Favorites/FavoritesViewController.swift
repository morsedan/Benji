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

        let query = PFUser.query()
        query?.findObjectsInBackground(block: { (allUsers, error) in
            guard let users = allUsers as? [PFUser] else { return }

            self.manager.set(newItems: users)
        })
    }
}
