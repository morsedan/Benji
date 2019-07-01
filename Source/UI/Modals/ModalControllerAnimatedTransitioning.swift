//
//  ModalControllerAnimatedTransitioning.swift
//  Benji
//
//  Created by Benji Dodgson on 6/30/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

// A custom transition for ModalController that blurs the background, fades in parts of the toVC
// while simultaneously sliding up some of its views.

class ModalControllerAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {

    var isPresenting = true
    var duration: TimeInterval = Theme.animationDuration

    private var modalAnimator: UIViewPropertyAnimator?

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let vcKey: UITransitionContextViewControllerKey = self.isPresenting ? .to : .from

        // Make sure we have all the components we need to complete this transition
        guard let presentedVC = transitionContext.viewController(forKey: vcKey)
            as? ModalViewController else {
                return
        }

        let containerView = transitionContext.containerView

        // Add blur view
        let blurView = self.addBlurViewIfNeeded(to: containerView)
        blurView.effect = self.isPresenting ? nil : UIBlurEffect(style: .dark)

        // Add view to present
        containerView.addSubview(presentedVC.view)

        // Initialize view to present position and alpha
        self.setMainContentPosition(isOffscreen: self.isPresenting, on: presentedVC)
        self.setSubviewsAlpha(self.isPresenting ? 0 : 1, on: presentedVC)

        self.modalAnimator?.stopAnimation(true)
        self.modalAnimator = UIViewPropertyAnimator(duration: self.transitionDuration(using: transitionContext),
                                                    dampingRatio: 1,
                                                    animations: nil)

        self.modalAnimator?.addAnimations { [unowned self] in

            UIView.animateKeyframes(withDuration: self.transitionDuration(using: nil),
                                    delay: 0,
                                    animations: {
                                        // Finish blurring the background before the modal moves into place
                                        // because it looks better
                                        UIView.addKeyframe(withRelativeStartTime: 0,
                                                           relativeDuration: 0.75) {
                                                            blurView.effect = self.isPresenting ?
                                                                UIBlurEffect(style: .dark) : nil
                                        }
            })

            self.setMainContentPosition(isOffscreen: !self.isPresenting, on: presentedVC)
            self.setSubviewsAlpha(self.isPresenting ? 1 : 0, on: presentedVC)
        }
        self.modalAnimator?.addCompletion { (position) in
            if position == .end {
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }

        self.modalAnimator?.startAnimation()
    }

    private func addBlurViewIfNeeded(to container: UIView) -> UIVisualEffectView {
        if let blurView = container.subviews(type: UIVisualEffectView.self).first {
            return blurView
        }

        let blurView = UIVisualEffectView(frame: container.bounds)
        container.addSubview(blurView)
        return blurView
    }

    private func setMainContentPosition(isOffscreen: Bool, on modal: ModalViewController) {
        if isOffscreen {
            modal.mainContent.top = modal.view.height
        } else {
            modal.mainContent.top = 0
        }
    }

    private func setSubviewsAlpha(_ alpha: CGFloat, on modal: ModalViewController) {
        for subview in modal.view.subviews {
            guard subview !== modal.mainContent else { continue }
            subview.alpha = alpha
        }
    }
}
