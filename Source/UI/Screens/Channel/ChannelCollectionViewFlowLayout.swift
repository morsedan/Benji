//
//  ChannelCollectionViewFlowLayout.swift
//  Benji
//
//  Created by Benji Dodgson on 12/28/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation
import ReactiveSwift

enum FlowLayoutState {
    case vertical
    case overlaped
}

class CollectionViewOverlappingLayout: UICollectionViewFlowLayout {

    var overlap: CGFloat = 30

    override init() {
        super.init()
        self.scrollDirection = .horizontal
        self.minimumInteritemSpacing = 0
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.scrollDirection = .horizontal
        self.minimumInteritemSpacing = 0
    }

    override var collectionViewContentSize: CGSize{
        let xSize = CGFloat(self.collectionView!.numberOfItems(inSection: 0)) * self.itemSize.width
        let ySize = CGFloat(self.collectionView!.numberOfSections) * self.itemSize.height

        var contentSize = CGSize(width: xSize, height: ySize)

        if self.collectionView!.bounds.size.width > contentSize.width {
            contentSize.width = self.collectionView!.bounds.size.width
        }

        if self.collectionView!.bounds.size.height > contentSize.height {
            contentSize.height = self.collectionView!.bounds.size.height
        }

        return contentSize
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        let attributesArray = super.layoutAttributesForElements(in: rect)
        let numberOfItems = self.collectionView!.numberOfItems(inSection: 0)

        for attributes in attributesArray! {
            var xPosition = attributes.center.x
            let yPosition = attributes.center.y

            if attributes.indexPath.row == 0 {
                attributes.zIndex = Int(INT_MAX) // Put the first cell on top of the stack
            } else {
                xPosition -= self.overlap * CGFloat(attributes.indexPath.row)
                attributes.zIndex = numberOfItems - attributes.indexPath.row //Other cells below the first one
            }

            attributes.center = CGPoint(x: xPosition, y: yPosition)
        }

        return attributesArray
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return UICollectionViewLayoutAttributes(forCellWith: indexPath)
    }
}

class OverlapCollectionViewLayout: UICollectionViewLayout {

    var preferredSize = CGSize(width: 200, height: 200)

    private let centerDiff: CGFloat = 40
    private var numberOfItems = 0

    private var updateItems = [UICollectionViewUpdateItem]()

    override func prepare() {
        super.prepare()
        numberOfItems = collectionView?.numberOfItems(inSection: 0) ?? 0
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
            let width = max(collectionView.bounds.width + 1, preferredSize.width + CGFloat((numberOfItems - 1)) * centerDiff)
            let height = collectionView.bounds.height - 1

            return CGSize(width: width, height: height)
        }
        return .zero
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var allAttributes = [UICollectionViewLayoutAttributes]()
        for index in 0 ..< numberOfItems {
            let indexPath = NSIndexPath(item: index, section: 0)
            allAttributes.append(layoutAttributesForItem(at: indexPath as IndexPath)!)
        }
        return allAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath as IndexPath)

        attributes.size = preferredSize
        let centerX = preferredSize.width / 2.0 + CGFloat(indexPath.item) * centerDiff
        let centerY = collectionView!.bounds.height / 2.0
        attributes.center = CGPoint(x: centerX, y: centerY)
        attributes.zIndex = indexPath.item

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
        for updateItem in updateItems {
            switch updateItem.updateAction {
            case .delete:
                if updateItem.indexPathBeforeUpdate == itemIndexPath {
                    let attributes = layoutAttributesForItem(at: itemIndexPath)
                    let translation = collectionView!.bounds.height
                    attributes?.transform = CGAffineTransform(translationX: 0, y: translation)
                    return attributes
                }
            case .move:
                if updateItem.indexPathBeforeUpdate == itemIndexPath {
                    return layoutAttributesForItem(at: updateItem.indexPathAfterUpdate!)
                }
            default:
                break
            }
        }
        let finalIndex = finalIndexForIndexPath(indexPath: itemIndexPath as NSIndexPath)
        let shiftedIndexPath = NSIndexPath(item: finalIndex, section: itemIndexPath.section)

        return layoutAttributesForItem(at: shiftedIndexPath as IndexPath)
    }


    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        updateItems.removeAll(keepingCapacity: true)
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

class BouncyLayout: UICollectionViewFlowLayout {

    public enum BounceStyle {
        case subtle
        case regular
        case prominent

        var damping: CGFloat {
            switch self {
            case .subtle: return 0.8
            case .regular: return 0.7
            case .prominent: return 0.5
            }
        }

        var frequency: CGFloat {
            switch self {
            case .subtle: return 2
            case .regular: return 1.5
            case .prominent: return 1
            }
        }
    }

    private var damping: CGFloat = BounceStyle.regular.damping
    private var frequency: CGFloat = BounceStyle.regular.frequency

    convenience init(style: BounceStyle) {
        self.init()

        self.damping = style.damping
        self.frequency = style.frequency
    }

    convenience init(damping: CGFloat, frequency: CGFloat) {
        self.init()

        self.damping = damping
        self.frequency = frequency
        self.invalidateLayout()
    }

    private lazy var animator: UIDynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)

    override func prepare() {
        super.prepare()
        guard let view = self.collectionView, let attributes = super.layoutAttributesForElements(in: view.bounds.insetBy(dx: -200, dy: -200))?.compactMap({ collectionView in collectionView.copy() as? UICollectionViewLayoutAttributes }) else { return }

        self.oldBehaviors(for: attributes).forEach { behavior in
            self.animator.removeBehavior(behavior)
        }

        self.newBehaviors(for: attributes).forEach { behavior in
            self.animator.addBehavior(behavior, self.damping, self.frequency)
        }
    }

    private func oldBehaviors(for attributes: [UICollectionViewLayoutAttributes]) -> [UIAttachmentBehavior] {
        let indexPaths = attributes.map { attribute in attribute.indexPath }

        return self.animator.behaviors.compactMap { dynamicBehavior in
            guard let behavior = dynamicBehavior as? UIAttachmentBehavior, let itemAttributes = behavior.items.first as? UICollectionViewLayoutAttributes else { return nil }
            return indexPaths.contains(itemAttributes.indexPath) ? nil : behavior
        }
    }

    private func newBehaviors(for attributes: [UICollectionViewLayoutAttributes]) -> [UIAttachmentBehavior] {
        let indexPaths = self.animator.behaviors.compactMap { behavior in
            ((behavior as? UIAttachmentBehavior)?.items.first as? UICollectionViewLayoutAttributes)?.indexPath
        }

        return attributes.compactMap { attribute in
            indexPaths.contains(attribute.indexPath) ? nil : UIAttachmentBehavior(item: attribute, attachedToAnchor: attribute.center.floored())
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.animator.items(in: rect) as? [UICollectionViewLayoutAttributes]
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.animator.layoutAttributesForCell(at: indexPath) ?? super.layoutAttributesForItem(at: indexPath)
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let view = self.collectionView else { return false }

        self.animator.behaviors.forEach { behavior in
            guard let behavior = behavior as? UIAttachmentBehavior, let item = behavior.items.first else { return }

            self.update(behavior: behavior, and: item, in: view, for: newBounds)
            self.animator.updateItem(usingCurrentState: item)
        }
        return !newBounds.size.equalTo(view.bounds.size)
    }

    private func update(behavior: UIAttachmentBehavior, and item: UIDynamicItem, in view: UICollectionView, for bounds: CGRect) {
        let delta = CGVector(dx: bounds.origin.x - view.bounds.origin.x, dy: bounds.origin.y - view.bounds.origin.y)
        let resistance = CGVector(dx: abs(view.panGestureRecognizer.location(in: view).x - behavior.anchorPoint.x) / 1000, dy: abs(view.panGestureRecognizer.location(in: view).y - behavior.anchorPoint.y) / 1000)

        switch scrollDirection {
        case .horizontal: item.center.x += delta.dx < 0 ? max(delta.dx, delta.dx * resistance.dx) : min(delta.dx, delta.dx * resistance.dx)
        case .vertical: item.center.y += delta.dy < 0 ? max(delta.dy, delta.dy * resistance.dy) : min(delta.dy, delta.dy * resistance.dy)
        }

        item.center.flooredInPlace()
    }
}
