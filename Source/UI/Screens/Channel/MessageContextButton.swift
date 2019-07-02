//
//  MessageContextButton.swift
//  Benji
//
//  Created by Benji Dodgson on 7/2/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class MessageContextButton: Button {

    let contextCircleTop = View()
    let contextCircleLeft = View()
    let contextCircleRight = View()
    let contextCircleCenter = View()
    let contextCircleBottom = View()

    init() {
        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initializeViews() {
        self.addSubview(self.contextCircleTop)
        self.addSubview(self.contextCircleBottom)
        self.addSubview(self.contextCircleLeft)
        self.addSubview(self.contextCircleRight)
        self.addSubview(self.contextCircleCenter)

        self.contextCircleCenter.set(backgroundColor: .white)
        self.contextCircleTop.set(backgroundColor: .white)
        self.contextCircleRight.set(backgroundColor: .white)
        self.contextCircleLeft.set(backgroundColor: .white)
        self.contextCircleBottom.set(backgroundColor: .white)

        self.layer.borderWidth = Theme.borderWidth
        self.layer.borderColor = Color.lightPurple.color.cgColor
        self.makeRound()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let circleSize = CGSize(width: 4, height: 4)
        let circleOffset: CGFloat = 4

        self.contextCircleCenter.size = circleSize
        self.contextCircleCenter.centerOnXAndY()

        self.contextCircleTop.size = circleSize
        self.contextCircleTop.bottom = self.contextCircleCenter.top - circleOffset
        self.contextCircleTop.centerOnX()

        self.contextCircleBottom.size = circleSize
        self.contextCircleBottom.top = self.contextCircleCenter.bottom + circleOffset
        self.contextCircleBottom.centerOnX()

        self.contextCircleRight.size = circleSize
        self.contextCircleRight.left = self.contextCircleCenter.right + circleOffset
        self.contextCircleRight.centerOnY()

        self.contextCircleLeft.size = circleSize
        self.contextCircleLeft.right = self.contextCircleCenter.left - circleOffset
        self.contextCircleLeft.centerOnY()
    }
}
