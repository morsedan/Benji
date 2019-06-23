//
//  CollectionViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 6/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class CollectionViewController<CellType: DisplayableCell & UICollectionViewCell, ManagerType: CollectionViewManager<CellType>>: ViewController {

    lazy var manager: ManagerType = {
        let manager = ManagerType.init(with: self.collectionView)
        manager.didSelect = { [unowned self] item, indexPath in
            self.didSelect(item: item, at: indexPath)
        }
        return manager
    }()

    let collectionView: CollectionView

    init(with collectionView: CollectionView) {
        self.collectionView = collectionView
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = self.collectionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.dataSource = self.manager
        self.collectionView.delegate = self.manager
    }

    func didSelect(item: CellType.ItemType, at indexPath: IndexPath) {}
}
