//
//  OrbCollectionViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 12/28/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

import TMROLocalization

class OrbCollectionViewController: CollectionViewController<OrbCell, CollectionViewManager<OrbCell>> {

    init() {
        super.init(with: CollectionView(layout: OrbCollectionViewLayout()))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initializeViews() {
        super.initializeViews()

        self.view.set(backgroundColor: .blue)

        self.collectionViewManager.onSelectedItem.signal.observeValues { [unowned self] (selectedItem) in
            guard let selectedItem = selectedItem else { return }
            self.didSelectOrb(item: selectedItem.item, at: selectedItem.indexPath)
        }

        self.collectionView.alpha = 0
        delay(0.3) {
            self.revealOrbs()
        }
    }

    private func revealOrbs() {
        var offset: CGFloat = 1.2

        switch ScreenSize.current {
        case .phoneSmall:
            offset = 0.8
        case .phoneMedium:
            offset = 1.1
        default:
            offset = 1.2
        }

        let centerOffsetX = (self.collectionView.contentSize.width - self.collectionView.frame.size.width) / 2
        let centerOffsetY = ((self.collectionView.contentSize.height - self.collectionView.frame.size.height) * offset) / 2
        let centerPoint = CGPoint(x: centerOffsetX, y: centerOffsetY)
        self.collectionView.setContentOffset(centerPoint, animated: true)

        UIView.animate(withDuration: Theme.animationDuration, delay: 0.3, options: [], animations: {
            self.collectionView.alpha = 1
        }, completion: nil)
    }

    // MARK: Functions to Override

    func didSelectOrb(item: OrbCell.ItemType, at indexPath: IndexPath) {
        guard let item = self.collectionViewManager.items.value[safe: indexPath.row] else { return }
        self.collectionViewManager.update(item: item)
    }
}
