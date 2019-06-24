//
//  StringStyle.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

struct StringStyle {
    var font: FontType
    var size: CGFloat
    var color: Color
    var kern: CGFloat

    init(font: FontType = .regular,
         size: CGFloat,
         color: Color,
         kern: CGFloat = 0) {

        self.font = font
        self.size = size
        self.color = color
        self.kern = kern
    }

    var attributes: [NSAttributedString.Key: Any] {
        return [NSAttributedString.Key.font: UIFont(name: self.font.rawValue, size: self.size)!,
                NSAttributedString.Key.kern: self.kern,
                NSAttributedString.Key.foregroundColor: self.color.color]
    }

    var rawValueAttributes: [String : Any] {
        var rawAttributes: [String : Any] = [:]

        let attributes = self.attributes
        for attribute in attributes {
            rawAttributes[attribute.key.rawValue] = attribute.value
        }
        return rawAttributes
    }
}
