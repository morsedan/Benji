//
//  Font.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

enum FontType {

    case display
    case displayThin
    case medium
    case mediumBold
    case regular
    case regularBold
    case small
    case smallBold

    var font: UIFont {
        switch self {
        case .display:
            return UIFont.systemFont(ofSize: self.size, weight: .heavy)
        case .displayThin:
            return UIFont.systemFont(ofSize: self.size, weight: .ultraLight)
        case .medium:
            return UIFont.systemFont(ofSize: self.size, weight: .regular)
        case .mediumBold:
            return UIFont.systemFont(ofSize: self.size, weight: .bold)
        case .regular:
            return UIFont.systemFont(ofSize: self.size, weight: .regular)
        case .regularBold:
            return UIFont.systemFont(ofSize: self.size, weight: .bold)
        case .small:
            return UIFont.systemFont(ofSize: self.size, weight: .regular)
        case .smallBold:
            return UIFont.systemFont(ofSize: self.size, weight: .bold)
        }

//        guard let customFont = UIFont(name: "CustomFont-Light", size: UIFont.labelFontSize) else {
//            fatalError("""
//        Failed to load the "CustomFont-Light" font.
//        Make sure the font file is included in the project and the font name is spelled correctly.
//        """
//            )
//        }
//        label.font = UIFontMetrics.default.scaledFont(for: customFont)
//        label.adjustsFontForContentSizeCategory = true
    }

    var size: CGFloat {
        switch self {
        case .display:
            return 40
        case .displayThin:
            return 40
        case .medium, .mediumBold:
            return 24
        case .regular, .regularBold:
            return 20
        case .small, .smallBold:
            return 14
        }
    }

    var kern: CGFloat {
        return 1
    }
}
