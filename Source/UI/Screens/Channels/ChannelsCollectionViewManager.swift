//
//  ChannelsCollectionViewManager.swift
//  Benji
//
//  Created by Benji Dodgson on 2/3/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient

class ChannelsCollectionViewManager: CollectionViewManager<ChannelCell> {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.width * 0.95, height: 60)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            return self.header(for: collectionView, at: indexPath)
        default:
            fatalError("NO HEADER FOR SECTION")
        }
    }

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(collectionView.size)
        return CGSize(width: collectionView.width * 0.95, height: 60)
    }

    private func header(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let cv = collectionView as? CollectionView else { return UICollectionReusableView() }

        let header = cv.dequeueReusableHeaderView(ChannelsSectionHeader.self, for: indexPath)
        header.configure(with: "Recent")
        return header
    }
}
