//
//  Color.swift
//  Benji
//
//  Created by Benji Dodgson on 12/25/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

enum Color: String, CaseIterable {

    case blue
    case green
    case black
    case red
    case white
    case clear
    case halfWhite

    var color: UIColor {
        switch self {
        case .blue:
            return #colorLiteral(red: 0.3843137255, green: 0, blue: 0.9176470588, alpha: 1)
        case .red:
            return #colorLiteral(red: 0.8666666667, green: 0.1725490196, blue: 0, alpha: 1)
        case .green:
            return #colorLiteral(red: 0, green: 0.7843137255, blue: 0.3254901961, alpha: 1)
        case .white:
            return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        case .clear:
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        case .halfWhite:
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        case .black:
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
}
