//
//  TableViewManager.swift
//  Benji
//
//  Created by Benji Dodgson on 7/3/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import ReactiveSwift
import GestureRecognizerClosures

class TableViewManager<CellType: DisplayableCell & UITableViewCell>: NSObject, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView

    var items = MutableProperty<[CellType.ItemType]>([])
    // A deep copied array representing the last state of the items.
    // Used to animate changes to the collection view
    private var previousItems: [CellType.ItemType]?

    var didSelect: (_ item: CellType.ItemType, _ indexPath: IndexPath) -> Void = { _, _ in }
    var didLongPress: (_ item: CellType.ItemType, _ indexPath: IndexPath) -> Void = { _, _ in }

    required init(with tableView: UITableView) {

        if let nib = CellType.nib {
            tableView.register(nib, forCellReuseIdentifier: CellType.reuseID)
        } else {
            tableView.register(CellType.self, forCellReuseIdentifier: CellType.reuseID)
        }

        self.tableView = tableView
        super.init()
        self.initialize()
    }

    func initialize() {}

    func set(newItems: [CellType.ItemType]) {
        self.updateCollectionView(items: newItems, modify: { [weak self] in
            guard let `self` = self else { return }
            self.items.value = newItems
        })
    }

    func append(item: CellType.ItemType,
                in section: Int = 0,
                with animation: UITableView.RowAnimation = .automatic) {

        guard self.items.value.count > 0 else {
            self.set(newItems: [item])
            return
        }

        guard !self.items.value.contains(item) else { return }

        let indexPath = IndexPath(item: self.items.value.count, section: section)
        self.items.value.append(item)
        self.tableView.insertRows(at: [indexPath], with: animation)
    }

    func update(item: CellType.ItemType,
                in section: Int = 0,
                with animation: UITableView.RowAnimation = .automatic) {

        var indexPath: IndexPath?
        for (index, existingItem) in self.items.value.enumerated() {
            if existingItem == item {
                indexPath = IndexPath(item: index, section: section)
                break
            }
        }

        guard let ip = indexPath else { return }

        self.items.value[ip.item] = item
        self.tableView.reloadRows(at: [ip], with: animation)
    }

    func delete(item: CellType.ItemType,
                in section: Int = 0,
                with animation: UITableView.RowAnimation = .automatic) {

        var indexPath: IndexPath?
        for (index, existingItem) in self.items.value.enumerated() {
            if existingItem == item {
                indexPath = IndexPath(item: index, section: section)
                break
            }
        }

        guard let ip = indexPath else { return }

        self.items.value.remove(at: ip.item)
        self.tableView.deleteRows(at: [ip], with: animation)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView?.isHidden = self.items.value.count > 0
        return self.items.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: CellType = tableView.dequeueReusableCell(withIdentifier: CellType.reuseID,
                                                           for: indexPath) as! CellType

        let item = self.items.value[safe: indexPath.row]
        cell.configure(with: item)
        //Reset all gestures
        cell.contentView.gestureRecognizers?.forEach({ (recognizer) in
            cell.contentView.removeGestureRecognizer(recognizer)
        })

        cell.contentView.onTap { [weak self] (tap) in
            guard let `self` = self, let item = self.items.value[safe: indexPath.row] else { return }
            self.didSelect(item, indexPath)
        }

        cell.contentView.onLongPress { [weak self] (longPress) in
            guard let `self` = self, let item = self.items.value[safe: indexPath.row] else { return }
            self.didLongPress(item, indexPath)
        }

        return self.managerWillDisplay(cell: cell, for: indexPath)
    }

    func managerWillDisplay(cell: CellType, for indexPath: IndexPath) -> CellType {
        return cell
    }

    private func updateCollectionView(items: [CellType.ItemType], modify: @escaping () -> Void) {

        self.reloadCollectionView(previousItems: self.previousItems ?? [],
                                  newItems: items,
                                  modify: modify)

        self.previousItems = items
    }

    private func reloadCollectionView(previousItems: [CellType.ItemType],
                                      newItems: [CellType.ItemType],
                                      modify: @escaping () -> Void) {

        self.tableView.reload(previousItems: previousItems,
                              newItems: newItems,
                              equalityOption: .equality,
                              modify: modify,
                              completion: nil)
    }
}
