//
//  CloseButton.swift
//  Benji
//
//  Created by Benji Dodgson on 7/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class CloseButton: Button {

    override func layoutSubviews() {
        super.layoutSubviews()

        self.size = CGSize(width: 25, height: 25)
        self.makeRound()
        self.layer.borderColor = Color.white.color.cgColor
        self.layer.borderWidth = 2
    }
}
