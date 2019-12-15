//
//  UIView+ScalingAnimation.swift
//  Benji
//
//  Created by Benji Dodgson on 12/15/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

private var viewCenterHandlerKey: UInt8 = 0
extension UIView {

    private(set) var originalCenter: CGPoint? {
        get {
            return self.getAssociatedObject(&viewCenterHandlerKey)
        }
        set {
            self.setAssociatedObject(key: &viewCenterHandlerKey, value: newValue)
        }
    }

    func scaleDown() {
        self.originalCenter = self.center
        let propertyAnimator = UIViewPropertyAnimator(duration: 0.6,
                                                      dampingRatio: 0.6) {
                                                        for subview in self.subviews {
                                                            subview.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                                                        }
                                                        self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                                                        if let center = self.originalCenter {
                                                            self.center = center
                                                            self.setNeedsLayout()
                                                        }
        }
        propertyAnimator.startAnimation()
    }

    func scaleUp() {
        let propertyAnimator = UIViewPropertyAnimator(duration: 0.6,
                                                      dampingRatio: 0.6) {
                                                        for subview in self.subviews {
                                                            subview.transform = .identity
                                                        }
                                                        self.transform = .identity
                                                        if let center = self.originalCenter {
                                                            self.center = center
                                                            self.setNeedsLayout()
                                                        }
        }
        propertyAnimator.startAnimation()
    }

}
