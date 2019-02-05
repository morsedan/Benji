//
//  Localized.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

protocol Localized {
    var identifier: String { get }
    var arguments: [Localized] { get }
    var defaultString: String? { get }
    func localized(withArguments arguments: [Localized]) -> Localized
}

func localized(_ localized: Localized) -> String {
    if let string = localized as? String {
        return string
    }
    return StringLibrary.shared.getLocalizedString(for: localized)
}
