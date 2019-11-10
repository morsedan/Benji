//
//  UIView+Extensions.swift
//  Benji
//
//  Created by Benji Dodgson on 12/25/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

extension UIView {

    var top: CGFloat {
        get {
            return self.frame.origin.y
        }

        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }

    var x: CGFloat {
        get {
            return self.frame.origin.x
        }

        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }

    var y: CGFloat {
        get {
            return self.frame.origin.y
        }

        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }

    var left: CGFloat {
        get {
            return self.frame.origin.x
        }

        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }

    var right: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }

        set {
            var frame = self.frame
            frame.origin.x = newValue - frame.size.width
            self.frame = frame
        }
    }

    var bottom: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }

        set {
            var frame = self.frame
            frame.origin.y = newValue - frame.size.height
            self.frame = frame
        }
    }

    var centerX: CGFloat {
        get {
            return self.center.x
        }

        set {
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
    }

    var centerY: CGFloat {
        get {
            return self.center.y
        }

        set {
            self.center = CGPoint(x: self.center.x, y: newValue)
        }
    }

    var proportionalWidth: CGFloat {
        return self.width * 0.8
    }

    func centerOnXAndY() {
        self.centerOnY()
        self.centerOnX()
    }

    func centerOnY() {
        if let theSuperView = self.superview {
            self.centerY = theSuperView.halfHeight
        }
    }

    func centerOnX() {
        if let theSuperView = self.superview {
            self.centerX = theSuperView.halfWidth
        }
    }

    var width: CGFloat {
        get {
            return self.frame.size.width
        }

        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }

    var height: CGFloat {
        get {
            return self.frame.size.height
        }

        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }

    var halfWidth: CGFloat {
        get {
            return 0.5*self.frame.size.width
        }
    }

    var halfHeight: CGFloat {
        get {
            return 0.5*self.frame.size.height
        }
    }

    var origin: CGPoint {
        get {
            return self.frame.origin
        }

        set {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
    }

    var size: CGSize {
        get {
            return CGSize(width: self.width, height: self.height)
        }

        set {
            self.width = newValue.width
            self.height = newValue.height
        }
    }

    var isVisible: Bool {
        get {
            return !self.isHidden
        }
        set {
            self.isHidden = !newValue
        }
    }

    func makeRound(masksToBounds: Bool = true) {
        self.layer.masksToBounds = masksToBounds
        self.layer.cornerRadius = self.halfHeight
    }

    func roundCorners() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = Theme.cornerRadius
    }

    func round(corners: UIRectCorner, size: CGSize) {
        let maskPath1 = UIBezierPath(roundedRect: self.bounds,
                                     byRoundingCorners: corners,
                                     cornerRadii: size)
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = self.bounds
        maskLayer1.path = maskPath1.cgPath
        self.layer.mask = maskLayer1
    }

    func removeAllSubviews() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }

    func findInSubviews(condition: (UIView) -> Bool) -> UIView? {
        for view in subviews {
            if condition(view) {
                return view
            } else {
                if let result = view.findInSubviews(condition: condition) {
                    return result
                }
            }
        }

        return nil
    }

    func addShadow(withOffset offset: CGFloat) {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: offset)
        self.layer.shadowRadius = 10
        self.layer.masksToBounds = false
    }

    func hideShadow() {
        self.layer.shadowOpacity = 0.0
    }

    func contains(_ other: UIView) -> Bool {
        let otherBounds = other.convert(other.bounds, to: nil)
        let selfBounds = self.convert(self.bounds, to: nil)

        return selfBounds.contains(otherBounds)
    }

    func currentFirstResponder() -> UIResponder? {

        if self.isFirstResponder {
            return self
        }

        for view in self.subviews {
            if let responder = view.currentFirstResponder() {
                return responder
            }
        }

        return nil
    }

    func layoutNow() {
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }

    func set(backgroundColor: Color) {
        self.backgroundColor = backgroundColor.color
    }

    func moveTo(_ x: CGFloat, _ y: CGFloat) {
        self.frame = CGRect(x: x, y: y, width: self.width, height: self.height)
    }

    func moveTo(_ origin: CGPoint) {
        self.moveTo(origin.x, origin.y)
    }

    func scaleDown() {
        let propertyAnimator = UIViewPropertyAnimator(duration: 0.6,
                                                      dampingRatio: 0.6) {
                                                        self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
        propertyAnimator.startAnimation()
    }

    func scaleUp() {
        let propertyAnimator = UIViewPropertyAnimator(duration: 0.6,
                                                      dampingRatio: 0.6) {
                                                        self.transform = CGAffineTransform.identity
        }
        propertyAnimator.startAnimation()
    }

    func subviews<T: UIView>(type : T.Type) -> [T] {

        var matchingViews: [T] = []

        for view in self.subviews {
            if let view = view as? T {
                matchingViews.append(view)
            }
        }

        return matchingViews
    }

    /// Completely fills the superview
    func expandToSuperviewSize() {
        guard let superview = self.superview else { return }
        self.frame = superview.bounds
    }
}

