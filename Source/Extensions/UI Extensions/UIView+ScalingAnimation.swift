//
//  UIView+ScalingAnimation.swift
//  Benji
//
//  Created by Benji Dodgson on 12/15/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

extension UIView {

    func scaleDown() {

        let propertyAnimator = UIViewPropertyAnimator(duration: 0.6,
                                                      dampingRatio: 0.6) {
                                                        self.transform = CGAffineTransform(scaleX: 0.95, y: 0.9)
        }
        propertyAnimator.startAnimation()
    }

    func scaleUp() {
        let propertyAnimator = UIViewPropertyAnimator(duration: 0.6,
                                                      dampingRatio: 0.6) {
                                                        self.transform = .identity
        }
        propertyAnimator.startAnimation()
    }
}
