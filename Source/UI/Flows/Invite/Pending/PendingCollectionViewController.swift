//
//  PendingInviteViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 2/8/20.
//  Copyright © 2020 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Contacts

class PendingCollectionViewController: CollectionViewController<PendingInviteCell, PendingCollectionViewManager>, Sizeable  {

    init() {
        let collectionView = PendingCollectionView()
        super.init(with: collectionView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.loadConnections()
    }

    func loadConnections() {
        /// Grab pending connections
        guard let query = Connection.query() else { return }

        query.whereKey(ConnectionKey.from.rawValue, equalTo: User.current()!)
        query.whereKey(ConnectionKey.status.rawValue, equalTo: Connection.Status.invited.rawValue)
        query.findObjectsInBackground { (objects, error) in
            if let connections = objects as? [Connection] {
                print(connections.count)
            } else if let error = error {
                print(error)
            }
        }
    }
}
