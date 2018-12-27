//
//  StringCasing.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

enum StringCasing {
    case unchanged
    case uppercase
    case lowercase
    case capitalized

    func format(string: String) -> String {
        switch self {
        case .unchanged:
            return string
        case .uppercase:
            return string.uppercased()
        case .lowercase:
            return string.lowercased()
        case .capitalized:
            return string.capitalized
        }
    }
}
