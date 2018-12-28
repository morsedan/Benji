//
//  TextDisplayable.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

protocol TextDisplayable {
    var title: Localized { get }
    var subtitle: Localized { get }
}

extension TextDisplayable {
    var displaySubtitle: Localized {
        return LocalString.empty
    }
}
