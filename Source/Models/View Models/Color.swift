//
//  Color.swift
//  Benji
//
//  Created by Benji Dodgson on 12/25/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

enum Color: String, CaseIterable {

    case background1
    case background2
    case background3
    case blue
    case purple
    case lightPurple
    case teal
    case orange
    case green
    case red
    case white
    case clear
    case black

    var color: UIColor {
        switch self {
        case .background1:
            return #colorLiteral(red: 0.05882352941, green: 0.06666666667, blue: 0.1294117647, alpha: 1)
        case .background2:
            return #colorLiteral(red: 0.1254901961, green: 0.1333333333, blue: 0.2784313725, alpha: 1)
        case .background3:
            return #colorLiteral(red: 0.1529411765, green: 0.1607843137, blue: 0.3215686275, alpha: 1)
        case .blue:
            return #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        case .purple:
            return #colorLiteral(red: 0.4078431373, green: 0.2666666667, blue: 1, alpha: 1)
        case .lightPurple:
            return #colorLiteral(red: 0.6156862745, green: 0.6352941176, blue: 0.9607843137, alpha: 1)
        case .red:
            return #colorLiteral(red: 1, green: 0.09019607843, blue: 0.2666666667, alpha: 1)
        case .teal:
            return #colorLiteral(red: 0, green: 0.9450980392, blue: 1, alpha: 1)
        case .green:
            return #colorLiteral(red: 0, green: 1, blue: 0.462745098, alpha: 1)
        case .white:
            return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        case .clear:
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        case .orange:
            return #colorLiteral(red: 1, green: 0.5960784314, blue: 0, alpha: 1)
        case .black:
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }

    var highlightColor: Color {
        switch self {
        default:
            return .clear
        }
    }
}
