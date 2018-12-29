//
//  ChannelCollectionViewFlowLayout.swift
//  Benji
//
//  Created by Benji Dodgson on 12/28/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ChannelCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
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
    }

    private lazy var animator: UIDynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)

    override func prepare() {
        super.prepare()
        guard let view = collectionView, let attributes = super.layoutAttributesForElements(in: view.bounds.insetBy(dx: -200, dy: -200))?.compactMap({ collectionView in collectionView.copy() as? UICollectionViewLayoutAttributes }) else { return }

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
        let indexPaths = animator.behaviors.compactMap { behavior in
            ((behavior as? UIAttachmentBehavior)?.items.first as? UICollectionViewLayoutAttributes)?.indexPath
        }

        return attributes.compactMap { attribute in
            indexPaths.contains(attribute.indexPath) ? nil : UIAttachmentBehavior(item: attribute, attachedToAnchor: attribute.center.floored())
        }
    }

    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.animator.items(in: rect) as? [UICollectionViewLayoutAttributes]
    }

    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.animator.layoutAttributesForCell(at: indexPath) ?? super.layoutAttributesForItem(at: indexPath)
    }

    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let view = collectionView else { return false }

        self.animator.behaviors.forEach { behavior in
            guard let behavior = behavior as? UIAttachmentBehavior, let item = behavior.items.first else { return }

            self.update(behavior: behavior, and: item, in: view, for: newBounds)
            self.animator.updateItem(usingCurrentState: item)
        }
        return view.bounds.width != newBounds.width
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
