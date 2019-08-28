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

class NewChannelCollectionViewManager: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let collectionView: NewChannelCollectionView

    var favorites: [Avatar] = []
    var contextTypes: [MessageContext] = []

    init(with collectionView: NewChannelCollectionView) {
        self.collectionView = collectionView
        super.init()
        self.initialize()
    }

    private func initialize() {
        for _ in 0...9 {
            self.favorites.append(Lorem.avatar())
        }

        MessageContext.allCases.forEach { (context) in
            self.contextTypes.append(context)
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let newSection = NewChannelSection(rawValue: section) else { return 0 }

        switch newSection {
        case .context:
            return self.contextTypes.count
        case .favorites:
            return self.favorites.count
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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.width, height: 50)
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
        let header: NewChannelSectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                                           withReuseIdentifier: "NewChannelSectionHeader",
                                                                                           for: indexPath) as! NewChannelSectionHeader
        let text = indexPath.section == 0 ? "Context" : "Favorites"
        header.label.set(text: text)
        return header
    }
}
