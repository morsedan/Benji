//
//  SmallSemiBoldLabel.swift
//  Benji
//
//  Created by Benji Dodgson on 9/10/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class SmallSemiBoldLabel: Label {

    func set(text: Localized,
             color: Color = .offWhite,
             alignment: NSTextAlignment = .left,
             lineBreakMode: NSLineBreakMode = .byWordWrapping,
             stringCasing: StringCasing = .unchanged) {

        let attributed = AttributedString(text,
                                          fontType: .smallSemiBold,
                                          color: color)
        self.set(attributed: attributed,
                 alignment: .left,
                 lineBreakMode: lineBreakMode,
                 stringCasing: .unchanged)
    }
}
