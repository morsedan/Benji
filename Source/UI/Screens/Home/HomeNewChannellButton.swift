//
//  NewChannelButton.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class HomeNewChannellButton: ImageViewButton {

    override func layoutSubviews() {
        super.layoutSubviews()

        self.imageView.centerX = self.halfWidth + 2
        self.imageView.centerY = self.halfHeight - 2
    }
}
