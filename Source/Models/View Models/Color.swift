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
    case darkGray

    var color: UIColor {
        switch self {
        case .blue:
            return #colorLiteral(red: 0.1607843137, green: 0.4745098039, blue: 1, alpha: 1)
        case .red:
            return #colorLiteral(red: 1, green: 0.09019607843, blue: 0.2666666667, alpha: 1)
        case .green:
            return #colorLiteral(red: 0, green: 0.9019607843, blue: 0.462745098, alpha: 1)
        case .white:
            return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        case .clear:
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        case .halfWhite:
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        case .black:
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        case .darkGray:
            return #colorLiteral(red: 0.2588235294, green: 0.2588235294, blue: 0.2588235294, alpha: 1)
        }
    }
}
