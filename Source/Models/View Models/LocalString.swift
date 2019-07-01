//
//  LocalString.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

struct LocalizedString: Localized {
    var identifier: String
    var arguments: [Localized]
    var defaultString: String?

    init(id: String,
         arguments: [Localized] = [],
         default: String?) {

        self.identifier = id
        self.arguments = arguments
        self.defaultString = `default`
    }

    func localized(withArguments arguments: [Localized]) -> Localized {
        return LocalizedString(id: self.identifier,
                               arguments: arguments,
                               default: self.defaultString)
    }
    
    static var empty: LocalizedString {
        return LocalizedString(id: "", default: "")
    }
}
