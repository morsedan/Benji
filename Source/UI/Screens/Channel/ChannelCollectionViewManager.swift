//
//  ChannelCollectionViewManager.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ChannelCollectionViewManager: CollectionViewManager<Message, ChannelCell> {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let item = self.items.value[safe: indexPath.row] else { return .zero }

        let text = localized(item.text)
        let width = collectionView.width * 0.8
        let height = text.height(withConstrainedWidth: width, font: ChannelCell.font)
        return CGSize(width: width, height: height)
    }

}
