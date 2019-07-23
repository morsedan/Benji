//
//  Display1Label.swift
//  Benji
//
//  Created by Benji Dodgson on 7/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class Display1Label: Label {

    func set(text: Localized) {
        let attributed = AttributedString(text,
                                          fontType: .display1,
                                          color: .white)

        self.set(attributed: attributed,
                 alignment: .left,
                 stringCasing: .capitalized)
    }
}
