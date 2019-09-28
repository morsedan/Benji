//
//  HomeAddButton.swift
//  Benji
//
//  Created by Benji Dodgson on 6/29/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class HomeAddButton: View {

    let imageView = UIImageView(image: #imageLiteral(resourceName: "add"))
    private let selectionFeedback = UIImpactFeedbackGenerator(style: .light)

    override func initializeSubviews() {
        super.initializeSubviews()
        
        self.set(backgroundColor: .purple)
        self.addSubview(self.imageView)

        self.layer.shadowColor = Color.black.color.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowRadius = 5
        self.layer.masksToBounds = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.makeRound()

        self.imageView.size = CGSize(width: self.width * 0.5, height: self.height * 0.5)
        self.imageView.centerOnXAndY()
    }

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first, let view = touch.view {
            self.selectionFeedback.impactOccurred()
            view.scaleDown()
        }
    }

    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if let touch = touches.first, let view = touch.view {
            view.scaleUp()
        }
    }

    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        if let touch = touches.first, let view = touch.view {
            view.scaleUp()
        }
    }
}
