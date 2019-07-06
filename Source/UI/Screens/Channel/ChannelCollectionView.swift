//
//  ChannelCollectionView.swift
//  Benji
//
//  Created by Benji Dodgson on 12/28/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ChannelCollectionView: CollectionView {

    lazy var emptyView = EmptyChannelView()

    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 14 
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        flowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.estimatedItemSize = CGSize(width: 255, height: 44)
        super.init(flowLayout: flowLayout)

        self.backgroundView = self.emptyView
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.emptyView.frame = self.backgroundView?.bounds ?? .zero
    }
}
