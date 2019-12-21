//
//  CancelButton.swift
//  Benji
//
//  Created by Benji Dodgson on 12/15/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class CancelButton: Button {

    override func initializeSubviews() {
        self.tintColor = Color.white.color
        self.setImage(UIImage(systemName: "xmark.square"), for: .normal)
        self.setImage(UIImage(systemName: "xmark.square.fill"), for: .highlighted)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.size = CGSize(width: 44, height: 44)
    }
}