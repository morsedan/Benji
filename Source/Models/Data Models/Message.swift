//
//  Message.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

class Message: DisplayableCellItem {
    var backgroundColor: Color {
        return .blue
    }

    func diffIdentifier() -> NSObjectProtocol {
        return String() as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }

    var text: Localized {
        return LocalString.empty
    }

    var photoUrl: URL? {
        return nil
    }

    var photo: UIImage? {
        return nil
    }
}
