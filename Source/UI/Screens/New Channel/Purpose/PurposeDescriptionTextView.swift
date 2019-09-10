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

        self.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)

        self.set(placeholder: "Briefly describe the purpose of this channel.", color: .lightPurple)
        self.returnKeyType = .done

        let styleAttributes = StringStyle(font: .regularSemiBold, color: .lightPurple).attributes
        self.typingAttributes = styleAttributes
    }
}
