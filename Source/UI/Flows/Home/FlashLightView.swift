//
//  FlashLightView.swift
//  Benji
//
//  Created by Benji Dodgson on 2/16/20.
//  Copyright © 2020 Benjamin Dodgson. All rights reserved.
//

import Foundation

class FlashLightView: View {

    private let gradient = CAGradientLayer()

    private let color: Color

    init(with color: Color = .background1) {
        self.color = color
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initializeSubviews() {
        super.initializeSubviews()

        self.set(backgroundColor: self.color)

//        self.gradient.colors = [self.color.color.cgColor,
//                                self.color.color.cgColor,
//                                self.color.color.withAlphaComponent(0.9).cgColor,
//                                self.color.color.withAlphaComponent(0.8).cgColor,
//                                self.color.color.withAlphaComponent(0.6).cgColor,
//                                self.color.color.withAlphaComponent(0).cgColor].reversed()
//        self.gradient.type = .axial
//        self.layer.addSublayer(self.gradient)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.gradient.frame = self.bounds
    }

    func animateOut(completion: CompletionOptional = nil) {
        UIView.animate(withDuration: Theme.animationDuration, animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.alpha = 0
        }) { (completed) in
            completion?()
        }
    }


    func animateIn(completion: CompletionOptional = nil) {
        UIView.animate(withDuration: Theme.animationDuration, animations: {
            self.transform = .identity
            self.alpha = 1
        }) { (completed) in
            completion?()
        }
    }
}

