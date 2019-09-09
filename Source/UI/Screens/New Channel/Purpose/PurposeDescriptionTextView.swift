//
//  PurposeDescriptionTextView.swift
//  Benji
//
//  Created by Benji Dodgson on 9/8/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class PurposeDescriptionTextView: TextView {

    override func initialize() {
        super.initialize()

        self.set(placeholder: "Briefly describe the purpose of this channel.", color: .white)
    }
}
