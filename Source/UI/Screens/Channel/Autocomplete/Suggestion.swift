//
//  Suggestion.swift
//  Benji
//
//  Created by Benji Dodgson on 10/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

struct Suggestion: DisplayableCellItem {

    enum SuggestionType {
        case foo
        case boo
    }

    var backgroundColor: Color {
        return .clear
    }

    var identifier: String

    func diffIdentifier() -> NSObjectProtocol {
        return self.identifier as NSObjectProtocol
    }


}
