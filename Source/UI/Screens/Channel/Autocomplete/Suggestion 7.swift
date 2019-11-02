//
//  Suggestion.swift
//  Benji
//
//  Created by Benji Dodgson on 10/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

enum SuggestionType: DisplayableCellItem {

    case text(String)

    var backgroundColor: Color {
        return .clear
    }

    func diffIdentifier() -> NSObjectProtocol {
        switch self {
        case .text(let text):
            return text as NSObjectProtocol
        }
    }
}
