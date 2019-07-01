//
//  ScrolledModalContainerView.swift
//  Benji
//
//  Created by Benji Dodgson on 6/30/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

protocol ScrolledModalContainerViewDelegate: class {
    func scrolledmodalContainerViewIsPanning(_ container: ScrolledModalContainerView,
                                     withProgress progress: Float)
    func scrolledModalContainerView(_ container: ScrolledModalContainerView,
                                    updated currentHeight: CGFloat)
    func scrolledModalContainerViewFinishedAnimating(_ container: ScrolledModalContainerView,
                                                     withProgress progress: Float)
}

class ScrolledModalContainerView: UIView {

    weak var delegate: ScrolledModalContainerViewDelegate?

    private var presentable: ScrolledModalControllerPresentable
    private var scrollView: UIScrollView? {
        return self.presentable.scrollView
    }

    var minSwipeVelocity: CGFloat = 1000

    private let collapsedHeight: CGFloat = 0
    private var expandedHeight: CGFloat = 100
    private(set) var currentHeight: CGFloat = 0 {
        didSet {
            guard self.currentHeight != oldValue else { return }
            self.delegate?.scrolledModalContainerView(self, updated: self.currentHeight)
        }
    }

    // A clamped value between 0 and 1. 0 is fully collapsed, 1 is fully expanded
    var progress: Float {
        return self.progressForHeight(self.currentHeight)
    }
    private func progressForHeight(_ height: CGFloat) -> Float {
        var value = height - self.collapsedHeight
        value = (0.0...1.0).clamp(value / (self.expandedHeight - self.collapsedHeight))
        return Float(value)
    }

    private var currentPan: UIPanGestureRecognizer?
    private var panStart: CGPoint?
    private var startHeight: CGFloat?

    init(presentable: ScrolledModalControllerPresentable) {
        self.presentable = presentable

        super.init(frame: CGRect.zero)

        self.scrollView?.bounces = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initialize(scrollingEnabled: Bool) {
        if scrollingEnabled {
            let panRecognizer = UIPanGestureRecognizer { [unowned self] panRecognizer in
                self.handle(panRecognizer: panRecognizer)
            }

            panRecognizer.delegate = self
            self.addGestureRecognizer(panRecognizer)

            let scrollViewPanRecognizer = UIPanGestureRecognizer { [unowned self] panRecognizer in
                self.handleScrollView(panRecognizer: panRecognizer)
            }
            scrollViewPanRecognizer.delegate = self
            self.scrollView?.addGestureRecognizer(scrollViewPanRecognizer)
        }
    }

    func setExpandedHeight(expandedHeight: CGFloat) {
        self.expandedHeight = expandedHeight
        self.currentHeight = self.expandedHeight
    }

    private func setCornerRadius(_ radius: CGFloat) {
        let maskLayer = CAShapeLayer()
        let rect = CGRect(x: 0, y: 0, width: self.width, height: self.expandedHeight)
        maskLayer.path = UIBezierPath(roundedRect: rect,
                                      byRoundingCorners: [.topLeft, .topRight],
                                      cornerRadii: CGSize(width: radius, height: radius)).cgPath
        self.layer.mask = maskLayer
        self.layer.masksToBounds = true
    }

    // MARK: TOUCH HANDLING

    private func handleScrollView(panRecognizer: UIPanGestureRecognizer) {
        // Only recognize pan gestures on the scrollView if it's scrolled to the top
        guard let sv = self.scrollView, sv.contentOffset.y <= 0.0 else {
            self.resetPan()
            return
        }
        self.handle(panRecognizer: panRecognizer)
    }

    func handle(panRecognizer: UIPanGestureRecognizer) {
        guard let superview = self.superview else { return }

        // Only allow one pan gesture to control at a time
        if self.currentPan != nil && self.currentPan !== panRecognizer {
            return
        }

        switch panRecognizer.state {
        case .began:
            self.initializePanIfNeeded(panRecognizer: panRecognizer)
        case .changed:
            self.initializePanIfNeeded(panRecognizer: panRecognizer)

            if let panStart = self.panStart, let startHeight = self.startHeight {
                let delta = panStart.y - panRecognizer.translation(in: superview).y
                self.currentHeight =
                    (self.collapsedHeight...self.expandedHeight).clamp(startHeight + delta)
            }
        case .ended, .cancelled, .failed:
            // Ensure we don't respond the end of an untracked pan gesture
            if self.currentPan != nil {
                self.animateToFinalPosition(withCurrentVelocity: panRecognizer.velocity(in: superview).y)
            }
            self.resetPan()
        case .possible:
            break
        @unknown default:
            break
        }

        self.delegate?.scrolledmodalContainerViewIsPanning(self, withProgress: self.progress)
    }

    private func initializePanIfNeeded(panRecognizer: UIPanGestureRecognizer) {
        if self.currentPan == nil {
            self.currentPan = panRecognizer
            self.panStart = panRecognizer.translation(in: superview)
            self.startHeight = self.currentHeight
        }
    }

    private func resetPan() {
        self.currentPan = nil
        self.panStart = nil
        self.startHeight = nil
    }

    // MARK: EXPAND/COLLAPSE ANIMATION

    private func animateToFinalPosition(withCurrentVelocity velocity: CGFloat) {
        let finalHeight: CGFloat
        var animationDuration: TimeInterval = Theme.animationDuration

        // If the user swipes fast enough, ignore the position and animate to the direction of the swipe
        // Try to make the animation match the velocity of the user's swipe
        if velocity < -self.minSwipeVelocity {
            finalHeight = self.expandedHeight
            animationDuration = Double((finalHeight - self.currentHeight)/abs(velocity))
        }
        else if velocity > self.minSwipeVelocity {
            finalHeight = self.collapsedHeight
            animationDuration = Double((self.currentHeight - finalHeight)/abs(velocity))
        }
            // Ignore swipe down gestures unless the table is scrolled to the top
        else if velocity > self.minSwipeVelocity, let sv = self.scrollView, sv.contentOffset.y <= 0.0 {
            finalHeight = self.collapsedHeight
            animationDuration = Double((self.currentHeight - finalHeight)/abs(velocity))
        }
        else if self.progress > 0.5 {
            finalHeight = self.expandedHeight
        } else {
            finalHeight = self.collapsedHeight
        }

        animationDuration = (0.0...Theme.animationDuration).clamp(animationDuration)

        self.animateToHeight(height: finalHeight, inTime: animationDuration)
    }

    func animateToHeight(height: CGFloat, inTime duration: TimeInterval = Theme.animationDuration) {

        UIView.animate(withDuration: duration,
                       delay: 0.01,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: {
                        self.currentHeight = height
        }) { didComplete in
            self.delegate?.scrolledModalContainerViewFinishedAnimating(self, withProgress: self.progress)
        }
    }
}

extension ScrolledModalContainerView: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
