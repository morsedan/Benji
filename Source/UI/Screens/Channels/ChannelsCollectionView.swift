//
//  ChannelsCollectionView.swift
//  Benji
//
//  Created by Benji Dodgson on 2/3/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ChannelsCollectionView: PagingCollectionView {

    init() {
        let flowLayout = PagingCollectionViewFlowLayout(portraitRatio: 0.8, landscapeRatio: 0.6)
        super.init(pagingLayout: flowLayout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
