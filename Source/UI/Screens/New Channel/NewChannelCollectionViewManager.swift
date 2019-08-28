//
//  NewChannelCollectionViewManager.swift
//  Benji
//
//  Created by Benji Dodgson on 8/27/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

enum NewChannelSection: Int {
    case context
    case favorites
}

class NewChannelCollectionViewManager: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {

    let collectionView: NewChannelCollectionView

    init(with collectionView: NewChannelCollectionView) {
        self.collectionView = collectionView
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let newSection = NewChannelSection(rawValue: section) else { return 0 }

        switch newSection {
        case .context:
            return 0
        case .favorites:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let newSection = NewChannelSection(rawValue: indexPath.section) else { return UICollectionViewCell() }

        switch newSection {
        case .context:
            return self.contextCell(for: collectionView, at: indexPath)
        case .favorites:
            return self.favoritesCell(for: collectionView, at: indexPath)
        }
    }

    private func contextCell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ContextCell = collectionView.dequeueReusableCell(withReuseIdentifier: ContextCell.reuseID,
                                                                for: indexPath) as! ContextCell
        return cell
    }

    private func favoritesCell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FavoriteCell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCell.reuseID,
                                                                   for: indexPath) as! FavoriteCell
        return cell
    }
}
