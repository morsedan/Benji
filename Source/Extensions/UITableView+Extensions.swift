//
//  UITableView+Extensions.swift
//  Benji
//
//  Created by Benji Dodgson on 12/28/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

extension UITableView {

    // Updates the heights of the cells and headers without reloading them
    func refreshHeights() {
        self.beginUpdates()
        self.endUpdates()
    }

    func reloadSections(withIndexSets indexSets: ListIndexSetResult,
                        completion: ((Bool) -> Swift.Void)? = nil) {

        guard indexSets.hasChanges else { return }

        let sanitizedSet: ListIndexSetResult = indexSets.forBatchUpdates()

        self.performBatchUpdates({
            self.deleteSections(sanitizedSet.deletes, with: UITableView.RowAnimation.automatic)
            self.insertSections(sanitizedSet.inserts, with: UITableView.RowAnimation.automatic)
            self.reloadSections(sanitizedSet.updates, with: UITableView.RowAnimation.automatic)
            for moveIndexSet in sanitizedSet.moves {
                self.moveSection(Int(moveIndexSet.from), toSection: Int(moveIndexSet.to))
            }
        }, completion: completion)
    }
}
