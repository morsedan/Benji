//
//  AutocompleteCollectionViewManager.swift
//  Benji
//
//  Created by Benji Dodgson on 10/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class SuggestionCollectionViewManager: CollectionViewManager<SuggestionCell> {

    /// holds keyboard appearance state for current textfield.
    var keyboardAppearance: UIKeyboardAppearance = .light

    override func initializeCollectionView() {
        super.initializeCollectionView()

        self.updateLayoutDataSource()
    }

    private func updateLayoutDataSource() {
        if let layout = self.collectionView.collectionViewLayout as? SuggestionCollectionViewFlowLayout {
            layout.dataSource = self
        }
    }

    override func managerWillDisplay(cell: SuggestionCell, for indexPath: IndexPath) {
        super.managerWillDisplay(cell: cell, for: indexPath)

        cell.backgroundStyle = self.keyboardAppearance
    }

    override func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let layout = collectionViewLayout as? SuggestionCollectionViewFlowLayout,
            let suggestion = self.items.value[safe: indexPath.row] else { return .zero }

        return layout.sizeForItem(at: indexPath, with: suggestion)
    }
}
