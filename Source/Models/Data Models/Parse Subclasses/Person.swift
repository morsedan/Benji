//
//  Person.swift
//  Benji
//
//  Created by Benji Dodgson on 11/2/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse

enum PersonKey: String {
    case givenName
    case familyName
    case email
    case phoneNumber
    case handle
    case smallImage
    case largeImage
    case connection
}

class Person: Object {

    var givenName: String? {
        get {
            return self.getObject(for: .givenName)
        }
        set {
            self.setObject(for: .givenName, with: newValue)
        }
    }

    var familyName: String? {
        get {
            return self.getObject(for: .familyName)
        }
        set {
            self.setObject(for: .familyName, with: newValue)
        }
    }

    var email: String? {
        get {
            return self.getObject(for: .email)
        }
        set {
            self.setObject(for: .email, with: newValue)
        }
    }

    var phoneNumber: String? {
        get {
            return self.getObject(for: .phoneNumber)
        }
        set {
            self.setObject(for: .phoneNumber, with: newValue)
        }
    }

    var handle: String? {
        get {
            return self.getObject(for: .handle)
        }
        set {
            self.setObject(for: .handle, with: newValue)
        }
    }

    var smallImage: PFFileObject? {
        get {
            return self.getObject(for: .smallImage)
        }
        set {
            self.setObject(for: .smallImage, with: newValue)
        }
    }

    var largeImage: PFFileObject? {
        get {
            return self.getObject(for: .largeImage)
        }
        set {
            self.setObject(for: .largeImage, with: newValue)
        }
    }

    var connection: PFRelation<PFObject>? {
        get {
            return self.getObject(for: .connection)
        }
        set {
            self.setObject(for: .connection, with: newValue)
        }
    }
}

extension Person: Objectable {
    typealias KeyType = PersonKey

    func getObject<Type>(for key: PersonKey) -> Type? {
        return self.object(forKey: key.rawValue) as? Type
    }

    func setObject<Type>(for key: PersonKey, with newValue: Type) {
        self.setObject(newValue, forKey: key.rawValue)
    }
}
