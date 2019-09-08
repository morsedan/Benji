//
//  NewChannelCollectionViewManager.swift
//  Benji
//
//  Created by Benji Dodgson on 8/27/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class FavoritesCollectionViewManager: CollectionViewManager<FavoriteCell> {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.width, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {
        case UICollectionView.elementKindSectionHeader:
            return self.header(for: collectionView, at: indexPath)
        case UICollectionView.elementKindSectionFooter:
            fatalError("NO FOOTER")
        default:
            fatalError("UNRECOGNIZED SECTION KIND")
        }
    }

    private func header(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionReusableView {
        let header: FavoritesSectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                                           withReuseIdentifier: "NewChannelSectionHeader",
                                                                                           for: indexPath) as! FavoritesSectionHeader
        let text = indexPath.section == 0 ? "Context" : "Favorites"
        header.label.set(text: text, alignment: .left, stringCasing: .uppercase)
        return header
    }

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
}
