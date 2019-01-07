//
//  ChannelCollectionViewFlowLayout.swift
//  Benji
//
//  Created by Benji Dodgson on 12/28/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation
import ReactiveSwift

class OverlapCollectionViewLayout: UICollectionViewLayout {

    var preferredSize: CGSize

    private let centerDiff: CGFloat = 0
    private var numberOfItems = 0

    private var updateItems = [UICollectionViewUpdateItem]()

    init(preferredSize: CGSize) {
        self.preferredSize = preferredSize
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepare() {
        super.prepare()
        guard let collectionView = self.collectionView else { return }

        self.numberOfItems = collectionView.numberOfItems(inSection: 0)
    }

    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        self.updateItems = updateItems
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override var collectionViewContentSize: CGSize {
        if let collectionView = collectionView {
            let width = max(collectionView.bounds.width + 1, self.preferredSize.width + CGFloat((self.numberOfItems - 1)) * self.centerDiff)
            let height = collectionView.bounds.height - 1

            return CGSize(width: width, height: height)
        }
        return .zero
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var allAttributes = [UICollectionViewLayoutAttributes]()
        for index in 0 ..< self.numberOfItems {
            let indexPath = NSIndexPath(item: index, section: 0)
            allAttributes.append(self.layoutAttributesForItem(at: indexPath as IndexPath)!)
        }
        return allAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = self.collectionView else { return nil }
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath as IndexPath)

        attributes.size = self.preferredSize
        let centerX = self.preferredSize.width / 2.0 + CGFloat(indexPath.item) * centerDiff
        let centerY = collectionView.bounds.height / 2.0
        attributes.center = CGPoint(x: centerX, y: centerY)
        attributes.zIndex = indexPath.item
        //Set alpha or blur to attributes?

        return attributes
    }

    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = layoutAttributesForItem(at: itemIndexPath as IndexPath)

        for updateItem in updateItems {
            switch updateItem.updateAction {
            case .insert:
                if updateItem.indexPathAfterUpdate == itemIndexPath {
                    let translation = collectionView!.bounds.height
                    attributes?.transform = CGAffineTransform(translationX: 0, y: translation)
                    break
                }
            default:
                break
            }
        }

        return attributes
    }

    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = self.collectionView else { return nil }

        for updateItem in self.updateItems {
            switch updateItem.updateAction {
            case .delete:
                if updateItem.indexPathBeforeUpdate == itemIndexPath {
                    let attributes = self.layoutAttributesForItem(at: itemIndexPath)
                    let translation = collectionView.bounds.height
                    attributes?.transform = CGAffineTransform(translationX: 0, y: translation)
                    return attributes
                }
            case .move:
                if updateItem.indexPathBeforeUpdate == itemIndexPath {
                    return self.layoutAttributesForItem(at: updateItem.indexPathAfterUpdate!)
                }
            default:
                break
            }
        }
        let finalIndex = self.finalIndexForIndexPath(indexPath: itemIndexPath as NSIndexPath)
        let shiftedIndexPath = NSIndexPath(item: finalIndex, section: itemIndexPath.section)

        return self.layoutAttributesForItem(at: shiftedIndexPath as IndexPath)
    }


    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        self.updateItems.removeAll(keepingCapacity: true)
    }

    private func finalIndexForIndexPath(indexPath: NSIndexPath) -> Int {
        var newIndex = indexPath.item
        for updateItem in updateItems {
            switch updateItem.updateAction {
            case .insert:
                if updateItem.indexPathAfterUpdate!.item <= newIndex {
                    newIndex += 1
                }
            case .delete:
                if updateItem.indexPathBeforeUpdate!.item < newIndex {
                    newIndex -= 1
                }
            case .move:
                if updateItem.indexPathBeforeUpdate!.item < newIndex {
                    newIndex -= 1
                }
                if updateItem.indexPathAfterUpdate!.item <= newIndex {
                    newIndex += 1
                }
            default:
                break
            }
        }
        return newIndex
    }
}
