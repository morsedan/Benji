//
//  NameLabel.swift
//  Benji
//
//  Created by Benji Dodgson on 6/30/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class NameLabel: Label {
    func set(text: Localized) {
        let attributed = AttributedString(text,
                                          fontType: .regularSemiBold,
                                          color: .white,
                                          kern: 0)

        self.set(attributed: attributed,
                 alignment: .left,
                 stringCasing: .capitalized)
    }
}
