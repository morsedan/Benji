//
//  CollectionView.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

class CollectionView: UICollectionView {

    let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)

    init(flowLayout: UICollectionViewFlowLayout) {
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        self.set(backgroundColor: .clear)
        self.initializeViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func scrollToLastItem() {
        let lastSection = self.numberOfSections - 1
        let lastRow = self.numberOfItems(inSection: lastSection)
        let indexPath = IndexPath(row: lastRow - 1, section: lastSection)
        self.scrollToItem(at: indexPath, at: .top, animated: true)
    }

    private func initializeViews() {
        self.addSubview(self.activityIndicator)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.activityIndicator.centerOnXAndY()
    }
}
