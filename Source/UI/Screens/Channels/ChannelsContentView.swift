//
//  ChannelsContentView.swift
//  Benji
//
//  Created by Benji Dodgson on 2/3/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ChannelsContentView: View {

    lazy var collectionView: ChannelsCollectionView = {
        return ChannelsCollectionView()
    }()

    override func initializeViews() {
        super.initializeViews()

        self.addSubview(self.collectionView)
        self.autoPinEdgesToSuperviewEdges()
    }
}
