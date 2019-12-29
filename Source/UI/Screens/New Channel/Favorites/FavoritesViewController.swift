//
//  FavoritesViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 9/8/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse 

class FavoritesViewController: OrbCollectionViewController {

    var totalHeight: CGFloat = 500
    
    override func initializeViews() {
        super.initializeViews()

        guard let objectId = User.current()?.objectId else { return }

        User.initializeArrayQuery(notEqualTo: objectId)
            .observe { (result) in
                switch result {
                case .success(let users):
                    self.setItems(from: users)
                case .failure(_):
                    break
                }
        }
    }

    private func setItems(from users: [User]) {

        var testUsers: [SystemAvatar] = []
        for _ in 0...10 {
            testUsers.append(Lorem.avatar())
        }
        let orbItems = testUsers.map { (user) in
            return OrbCellItem(id: String(optional: user.userObjectID),
                               avatar: AnyHashableDisplayable(user))
        }



        self.collectionViewManager.set(newItems: orbItems)
    }
}
