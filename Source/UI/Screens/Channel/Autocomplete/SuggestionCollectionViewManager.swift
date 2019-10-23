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

    override func managerWillDisplay(cell: SuggestionCell, for indexPath: IndexPath) {
        super.managerWillDisplay(cell: cell, for: indexPath)

        cell.backgroundStyle = self.keyboardAppearance
    }
}
