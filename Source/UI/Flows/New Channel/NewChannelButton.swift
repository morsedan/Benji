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

    private var xOffset: CGFloat = 0
    private var yOffset: CGFloat = 0

    override var isEnabled: Bool {
        didSet {
            self.iconImageView.tintColor = self.isEnabled ? Color.purple.color : Color.purple.color.withAlphaComponent(0.5)
            self.isUserInteractionEnabled = self.isEnabled
        }
    }

    override func initializeSubviews() {
        super.initializeSubviews()

        self.shouldScale = false 
        self.addSubview(self.iconImageView)
        self.iconImageView.tintColor = Color.purple.color
        self.iconImageView.contentMode = .scaleAspectFit
        self.set(style: .normal(color: .purple, text: ""))
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.makeRound()

        self.iconImageView.size = CGSize(width: self.width * 0.55, height: self.height * 0.55)
        self.iconImageView.centerX = self.halfWidth + self.xOffset
        self.iconImageView.centerY = self.halfHeight + self.yOffset
    }

    func update(for contentType: NewChannelContent) {
        UIView.animate(withDuration: Theme.animationDuration,
                       animations: {
                        self.iconImageView.alpha = 0
                        self.iconImageView.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
        }) { (completed) in
            switch contentType {
            case .purpose(_):
                self.iconImageView.image = UIImage(systemName: "person.badge.plus")
                self.iconImageView.tintColor = Color.purple.color
                self.xOffset = -1
                self.yOffset = 0
            case .favorites(_):
                self.iconImageView.image = UIImage(systemName: "square.and.pencil")
                self.iconImageView.tintColor = Color.purple.color
                self.xOffset = 2
                self.yOffset = -2
            }

            self.layoutNow()

            UIView.animate(withDuration: Theme.animationDuration) {
                self.iconImageView.alpha = 1
                self.iconImageView.transform = .identity
            }
        }
    }
}
