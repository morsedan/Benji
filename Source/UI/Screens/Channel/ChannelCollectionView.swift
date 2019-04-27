//
//  ChannelCollectionView.swift
//  Benji
//
//  Created by Benji Dodgson on 12/28/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ChannelCollectionView: CollectionView {

    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 90, right: 0)
        super.init(flowLayout: flowLayout)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
