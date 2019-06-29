//
//  AttributedString.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

struct AttributedString {

    var localizedString: Localized
    var style: StringStyle

    var string: NSMutableAttributedString {
        let plainString = localized(self.localizedString)
        return NSMutableAttributedString(string: plainString, attributes: self.style.attributes)
    }

    var attributes: [NSAttributedString.Key : Any] {
        return self.style.attributes
    }

    init(_ localized: Localized,
         fontType: FontType = .regular,
         color: Color,
         kern: CGFloat = 0) {

        let style = StringStyle(font: fontType,
                                color: color,
                                kern: kern)
        self.init(localized, style: style)
    }

    init(_ localized: Localized, style: StringStyle) {
        self.localizedString = localized
        self.style = style
    }

    func wrapNeeded(for length: CGFloat) -> Bool {
        return self.string.size().width > length
    }
}
