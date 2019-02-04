//
//  TCHChannel+Extensions.swift
//  Benji
//
//  Created by Benji Dodgson on 2/3/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient

extension TCHChannel: Diffable, DisplayableCellItem {
    
    var backgroundColor: Color {
        return .gray
    }

    func diffIdentifier() -> NSObjectProtocol {
        return String(optional: self.sid) as NSObjectProtocol
    }
}
