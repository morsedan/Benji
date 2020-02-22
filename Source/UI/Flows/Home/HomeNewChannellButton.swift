//
//  NewChannelButton.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class HomeNewChannellButton: ImageViewButton {

    override func initializeSubviews() {
        super.initializeSubviews()

        self.imageView.tintColor = Color.purple.color
        self.imageView.image = UIImage(systemName: "square.and.pencil")
        self.backgroundColor = Color.purple.color.withAlphaComponent(0.4)

        self.layer.borderColor = Color.purple.color.cgColor
        self.layer.borderWidth = 2
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.imageView.centerX = self.halfWidth + 2
        self.imageView.centerY = self.halfHeight - 2
    }
}
