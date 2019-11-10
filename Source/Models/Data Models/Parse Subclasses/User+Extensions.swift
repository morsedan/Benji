//
//  User+Extensions.swift
//  Benji
//
//  Created by Benji Dodgson on 11/3/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse

extension User: Avatar {

    var user: User? {
        return User.current()
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
        guard let current = User.current(),
            !current.givenName.isEmpty,
            let last = current.familyName.first,
            let position = self.reservation?.position else { return } 
        var positionString = String(position)
        let start = positionString.startIndex
        let end = positionString.index(positionString.startIndex, offsetBy: 1)
        positionString = positionString.replacingCharacters(in: start...end, with: "")
        let handleString = String(current.givenName) + String(last) + "_" + positionString
        self.handle = handleString.lowercased()
    }

    static func anonymousLogin() -> Future<User> {
        let promise = Promise<User>()
        PFAnonymousUtils.logIn { (user, error) in
            if let anonymousUser = user as? User {
                promise.resolve(with: anonymousUser)
            } else if let error = error {
                promise.reject(with: error)
            } else {
                promise.reject(with: ClientError.generic)
            }
        }
        return promise 
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

extension User {
    
    func formatName(from text: String) {
        let components = text.components(separatedBy: " ").filter { (component) -> Bool in
            return !component.isEmpty
        }
        if let first = components.first {
            self.givenName = first
        }
        if let last = components.last {
            self.familyName = last
        }
    }
}