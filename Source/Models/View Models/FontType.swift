//
//  Font.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

enum FontType {

    case display1
    case display2
    case medium
    case regular
    case regularSemiBold
    case regularBold
    case small
    case smallSemiBold
    case xSmall
    case xxSmall
    case xxSmallSemiBold

    var font: UIFont {
        switch self {
        case .display1:
            return UIFont(name: "AvenirNext-Bold", size: self.size)!
        case .display2:
            return UIFont(name: "AvenirNext-Bold", size: self.size)!
        case .medium:
            return UIFont(name: "AvenirNext-Regular", size: self.size)!
        case .regular:
            return UIFont(name: "AvenirNext-Regular", size: self.size)!
        case .regularSemiBold:
            return UIFont(name: "AvenirNext-Medium", size: self.size)!
        case .regularBold:
            return UIFont(name: "AvenirNext-Bold", size: self.size)!
        case .small:
            return UIFont(name: "AvenirNext-Regular", size: self.size)!
        case .smallSemiBold:
            return UIFont(name: "AvenirNext-Medium", size: self.size)!
        case .xSmall:
            return UIFont(name: "AvenirNext-Regular", size: self.size)!
        case .xxSmall:
             return UIFont(name: "AvenirNext-Regular", size: self.size)!
        case .xxSmallSemiBold:
             return UIFont(name: "AvenirNext-Bold", size: self.size)!
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
        case .display1:
            return 40
        case .display2:
            return 28
        case .medium:
            return 20
        case .regular, .regularBold, .regularSemiBold:
            return 19
        case .small, .smallSemiBold:
            return 15
        case .xSmall:
            return 13
        case .xxSmall, .xxSmallSemiBold:
            return 11
        }
    }

    var kern: CGFloat {
        return 1
    }
}
