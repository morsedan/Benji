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
    case blue2
    case blue3
    case blue4
    case red
    case yellow
    case hotGreen
    case orange
    case ladderOrange
    case white
    case clear
    case halfWhite

    var color: UIColor {
        switch self {
        case .blue:
            return #colorLiteral(red: 0, green: 0.4509803922, blue: 0.7294117647, alpha: 1)
        case .blue2:
            return #colorLiteral(red: 0.337254902, green: 0.7490196078, blue: 0.9568627451, alpha: 1)
        case .blue3:
            return #colorLiteral(red: 0.6666666667, green: 0.8901960784, blue: 0.9764705882, alpha: 1)
        case .blue4:
            return #colorLiteral(red: 0.8980392157, green: 0.968627451, blue: 0.9960784314, alpha: 1)
        case .red:
            return #colorLiteral(red: 1, green: 0.1882352941, blue: 0.1137254902, alpha: 1)
        case .yellow:
            return #colorLiteral(red: 0.9843137255, green: 0.831372549, blue: 0.07450980392, alpha: 1)
        case .hotGreen:
            return #colorLiteral(red: 0.1490196078, green: 0.8941176471, blue: 0.4039215686, alpha: 1)
        case .orange:
            return #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        case .ladderOrange:
            return #colorLiteral(red: 0.9960784314, green: 0.2784313725, blue: 0.2784313725, alpha: 1)
        case .white:
            return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        case .clear:
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        case .halfWhite:
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        }
    }
}
