//
//  OrbCollectionView.swift
//  Benji
//
//  Created by Benji Dodgson on 12/28/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class OrbCollectionView: CollectionView {

    init() {
        super.init(layout: OrbCollectionViewLayout())
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false 
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
