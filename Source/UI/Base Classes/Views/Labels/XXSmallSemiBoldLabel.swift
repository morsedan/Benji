//
//  XxSmallSemiBoldLabel.swift
//  Benji
//
//  Created by Benji Dodgson on 10/6/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class XXSmallSemiBoldLabel: Label {

    func set(text: Localized,
                color: Color = .background4,
                alignment: NSTextAlignment = .left,
                lineBreakMode: NSLineBreakMode = .byWordWrapping,
                stringCasing: StringCasing = .unchanged) {

           let attributed = AttributedString(text,
                                             fontType: .xxSmallSemiBold,
                                             color: color)
           self.set(attributed: attributed,
                    alignment: .left,
                    lineBreakMode: lineBreakMode,
                    stringCasing: .unchanged)
    }
}
