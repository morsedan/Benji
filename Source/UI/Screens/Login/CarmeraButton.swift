//
//  CarmeraButton.swift
//  Benji
//
//  Created by Benji Dodgson on 10/12/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class CameraButton: View {

    private let innerCircle = View()
    private let selectionFeedback = UIImpactFeedbackGenerator(style: .light)

    override func initializeSubviews() {
        super.initializeSubviews()

        self.addSubview(self.innerCircle)

        self.innerCircle.layer.borderColor = Color.background1.color.cgColor
        self.innerCircle.layer.borderWidth = 4

        self.set(backgroundColor: .white)
        self.innerCircle.set(backgroundColor: .white)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.innerCircle.size = CGSize(width: self.width - 10, height: self.height - 10)
        self.innerCircle.centerOnXAndY()
        self.innerCircle.makeRound()

        self.makeRound()
    }

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.selectionFeedback.impactOccurred()
        self.innerCircle.scaleDown()
    }

    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.innerCircle.scaleUp()
    }

    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.innerCircle.scaleUp()
    }
}
