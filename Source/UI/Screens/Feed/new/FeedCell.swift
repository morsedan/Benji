//
//  FeedCell.swift
//  Benji
//
//  Created by Benji Dodgson on 6/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient

class FeedCell: UICollectionViewCell {

    weak var delegate: FeedDelegate?
    let textView = FeedTextView()
    let avatarView = AvatarView()

//    override func initialize() {
//
//        self.addSubview(self.textView)
//        self.addSubview(self.avatarView)
//
//        self.set(backgroundColor: .background3)
//        self.roundCorners()
//        self.addShadow(withOffset: 20)
//    }

    func configure(with item: FeedType) {
        switch item {
        case .system(let systemMessage):
            self.textView.set(localizedText: systemMessage.body)
            self.avatarView.set(avatar: systemMessage.avatar)
        case .message(_):
            break
        }
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        self.layer.zPosition = CGFloat(layoutAttributes.zIndex)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.isHidden = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.textView.size = CGSize(width: self.width * 0.85, height: self.height * 0.5)
        self.textView.top = 40
        self.textView.centerOnX()

        self.avatarView.size = CGSize(width: 24, height: 24)
        self.avatarView.bottom = self.height - 100
        self.avatarView.centerOnX()
    }

    /**
     This function animates the card. The animation consists of a rotation and translation.
     - parameter angle: The angle the card rotates while animating.
     - parameter horizontalTranslation: The horizontal translation the card animates in.
     */
    func animateCard(angle: CGFloat, horizontalTranslation: CGFloat) {

        self.delegate?.didDragCard(cell: self, swipeDirection: determineCardSwipeDirection())

        var transform = CATransform3DIdentity
        transform = CATransform3DRotate(transform, angle, 0, 0, 1)
        transform = CATransform3DTranslate(transform, horizontalTranslation, 0, 1)

        self.layer.transform = transform
    }

    /**
     Resets the CardCell back to the center of the VerticalCardSwiperView.
     */
    func resetToCenterPosition() {

        let cardCenterX = self.frame.midX
        let centerX = self.bounds.midX
        let initialSpringVelocity = abs(cardCenterX - centerX)/100

        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: initialSpringVelocity,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
                        guard let `self` = self else { return }
                        self.layer.transform = CATransform3DIdentity
        })
    }

    /**
     Called when the pan gesture is ended.
     Handles what happens when the user stops swiping a card.
     If a certain treshold of the screen is swiped, the `animateOffScreen` function is called,
     if the threshold is not reached, the card will be reset to the center by calling `resetToCenterPosition`.
     - parameter angle: The angle of the animation, depends on the direction of the swipe.
     */
    func endedPanAnimation(angle: CGFloat) {

        let swipePercentageMargin = self.bounds.width * 0.4
        let cardCenterX = self.frame.midX
        let centerX = self.bounds.midX

        // check for left or right swipe and if swipePercentageMargin is reached or not
        if cardCenterX < centerX - swipePercentageMargin || cardCenterX > centerX + swipePercentageMargin {
            self.animateOffScreen(angle: angle)
        } else {
            self.resetToCenterPosition()
        }
    }

    /**
     Animates to card off the screen and calls the `willSwipeAway` and `didSwipeAway` functions from the `CardDelegate`.
     - parameter angle: The angle that the card will rotate in (depends on direction). Positive means the card is swiped to the right, a negative angle means the card is swiped to the left.
     */
    private func animateOffScreen(angle: CGFloat) {

        var transform = CATransform3DIdentity
        let direction = self.determineCardSwipeDirection()

        transform = CATransform3DRotate(transform, angle, 0, 0, 1)

        switch direction {
        case .Left:
            transform = CATransform3DTranslate(transform, -(self.frame.width * 2), 0, 1)
        case .Right:
            transform = CATransform3DTranslate(transform, (self.frame.width * 2), 0, 1)
        default:
            break
        }
        self.delegate?.willSwipeAway(cell: self, swipeDirection: direction)

        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.layer.transform = transform
            }, completion: { _ in
                self.isHidden = true
                self.delegate?.didSwipeAway(cell: self, swipeDirection: direction)
        })
    }

    private func determineCardSwipeDirection() -> SwipeDirection {

        let cardCenterX = self.frame.midX
        let centerX = self.bounds.midX

        if cardCenterX < centerX {
            return .Left
        } else if cardCenterX > centerX {
            return .Right
        } else {
            return .None
        }
    }
}
