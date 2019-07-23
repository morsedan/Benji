//
//  ListViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 7/3/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ListViewController<CellType: DisplayableCell & UITableViewCell, ManagerType: TableViewManager<CellType>>: ViewController {

    lazy var manager: ManagerType = {
        let manager = ManagerType.init(with: self.tableView)
        manager.didSelect = { [unowned self] item, indexPath in
            self.didSelect(item: item, at: indexPath)
        }
        return manager
    }()

    let tableView: TableView

    init(with tableView: TableView) {
        self.tableView = tableView
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = self.tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self.manager
        self.tableView.delegate = self.manager
    }

    func didSelect(item: CellType.ItemType, at indexPath: IndexPath) {}
}
