//
//  ChannelsCollectionView.swift
//  Benji
//
//  Created by Benji Dodgson on 2/3/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ChannelsCollectionView: CollectionView {

    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        super.init(flowLayout: flowLayout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
