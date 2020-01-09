//
//  ReadAllFooterReusableView.swift
//  Benji
//
//  Created by Benji Dodgson on 1/8/20.
//  Copyright © 2020 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ReadAllFooterView: UICollectionReusableView {

    var isAnimatingFinal: Bool = false
    var currentTransform: CGAffineTransform?
    let label = RegularLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializeViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initializeViews() {
        self.addSubview(self.label)
        self.label.set(text: "Set all messages to read?")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.label.setSize(withWidth: self.width - 20)
        self.label.centerOnXAndY()
    }

    func setTransform(inTransform: CGAffineTransform, scaleFactor: CGFloat) {
        guard !self.isAnimatingFinal else { return }

        self.currentTransform = inTransform
        self.label.transform = CGAffineTransform.init(scaleX: scaleFactor, y: scaleFactor)
    }

    //reset the animation
    func prepareInitialAnimation() {
        self.isAnimatingFinal = false
        self.label.transform = CGAffineTransform.init(scaleX: 0.0, y: 0.0)
    }

    func startAnimate() {
        self.isAnimatingFinal = true
    }

    func stopAnimation() {
        self.isAnimatingFinal = false
    }

    //final animation to display loading
    func animateFinal() {
        guard !self.isAnimatingFinal else { return }

        self.isAnimatingFinal = true
        UIView.animate(withDuration: 0.2) {
            self.label.transform = .identity
        }
    }
}
