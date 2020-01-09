//
//  ReadAllFooterReusableView.swift
//  Benji
//
//  Created by Benji Dodgson on 1/8/20.
//  Copyright © 2020 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ReadAllFooterView: UICollectionReusableView {

    let refreshControlIndicator = UIActivityIndicatorView()
    var isAnimatingFinal: Bool = false
    var currentTransform: CGAffineTransform?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initializeViews() {
        self.addSubview(self.refreshControlIndicator)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.refreshControlIndicator.centerOnXAndY()
    }

    func setTransform(inTransform: CGAffineTransform, scaleFactor: CGFloat) {
        guard !self.isAnimatingFinal else { return }

        self.currentTransform = inTransform
        self.refreshControlIndicator.transform = CGAffineTransform.init(scaleX: scaleFactor, y: scaleFactor)
    }

    //reset the animation
    func prepareInitialAnimation() {
        self.isAnimatingFinal = false
        self.refreshControlIndicator.stopAnimating()
        self.refreshControlIndicator.transform = CGAffineTransform.init(scaleX: 0.0, y: 0.0)
    }

    func startAnimate() {
        self.isAnimatingFinal = true
        self.refreshControlIndicator.startAnimating()
    }

    func stopAnimation() {
        self.isAnimatingFinal = false
        self.refreshControlIndicator.stopAnimating()
    }

    //final animation to display loading
    func animateFinal() {
        guard !self.isAnimatingFinal else { return }

        self.isAnimatingFinal = true
        UIView.animate(withDuration: 0.2) {
            self.refreshControlIndicator.transform = .identity
        }
    }
}
