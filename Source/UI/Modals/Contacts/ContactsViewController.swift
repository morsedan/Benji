//
//  ContactsViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 6/30/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ContactsViewController: CollectionViewController<ContactCell, ContactsCollectionViewManager>, ScrolledModalControllerPresentable {

    var topMargin: CGFloat = 100

    var scrollView: UIScrollView? {
        return self.collectionView
    }

    var scrollingEnabled: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.set(backgroundColor: .background3)
    }
}
