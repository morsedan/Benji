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
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func scrollToBottom(animated: Bool = true) {
        let collectionViewContentHeight = collectionViewLayout.collectionViewContentSize.height

        self.performBatchUpdates(nil) { _ in
            self.scrollRectToVisible(CGRect(x: 0.0,
                                            y: collectionViewContentHeight - 1.0,
                                            width: 1.0, height: 1.0),
                                     animated: animated)
        }
    }

    func initialize() {
        self.addSubview(self.activityIndicator)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.activityIndicator.centerOnXAndY()
    }

    func register<T: UICollectionViewCell>(_ cellClass: T.Type) {
        self.register(cellClass, forCellWithReuseIdentifier: String(describing: T.self))
    }

    /// Registers a reusable view for a specific SectionKind
    public func register<T: UICollectionReusableView>(_ reusableViewClass: T.Type,
                                                      forSupplementaryViewOfKind kind: String) {
        self.register(reusableViewClass,
                      forSupplementaryViewOfKind: kind,
                      withReuseIdentifier: String(describing: T.self))
    }
}
