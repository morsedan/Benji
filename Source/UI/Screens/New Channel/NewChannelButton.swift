//
//  NewChannelButton.swift
//  Benji
//
//  Created by Benji Dodgson on 12/26/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class NewChannelButton: LoadingButton {

    let iconImageView = UIImageView()
    private let selectionFeedback = UIImpactFeedbackGenerator(style: .light)

    override var isEnabled: Bool {
        didSet {
            self.iconImageView.tintColor = self.isEnabled ? Color.white.color : Color.white.color.withAlphaComponent(0.4)
        }
    }

    override func initializeSubviews() {
        super.initializeSubviews()

        self.addSubview(self.iconImageView)
        self.iconImageView.tintColor = Color.white.color
        self.iconImageView.contentMode = .scaleAspectFit
        self.set(style: .normal(color: .purple, text: ""))
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.makeRound()

        self.iconImageView.size = CGSize(width: self.width * 0.55, height: self.height * 0.55)
        self.iconImageView.centerX = self.halfWidth + 2
        self.iconImageView.centerY = self.halfHeight - 2
    }

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.selectionFeedback.impactOccurred()
    }
}
