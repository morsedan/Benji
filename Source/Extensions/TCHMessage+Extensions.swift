//
//  TCHMessages+Extensions.swift
//  Benji
//
//  Created by Benji Dodgson on 2/3/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient
import Parse

extension TCHMessage: Diffable, DisplayableCellItem {
    var backgroundColor: Color {
        get {
            return self.isFromCurrentUser ? .blue : .gray
        }
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return String(optional: self.sid) as NSObjectProtocol
    }

    var isFromCurrentUser: Bool {
        guard let author = self.author else { return false }
        return author == PFUser.current()?.username
    }
}
