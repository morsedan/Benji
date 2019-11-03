//
//  User+Extensions.swift
//  Benji
//
//  Created by Benji Dodgson on 11/3/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

extension User: Avatar {

    var givenName: String {
        return String(optional: self.person?.givenName)
    }

    var familyName: String {
        return String(optional: self.person?.familyName)
    }

    var userObjectID: String? {
        self.objectId
    }

    var image: UIImage? {
        return nil
    }
}

extension User {

    func createHandle() {
        guard let me = User.me,
            let first = me.givenName.first,
            let last = me.familyName.first,
            let position = self.reservation?.position else { return } //Change to reservation count

        self.handle = String(first) + String(last) + "_" + String(position)
    }
}

extension User: DisplayableCellItem {

    var backgroundColor: Color {
        return .red
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self.objectId! as NSObjectProtocol
    }
}
