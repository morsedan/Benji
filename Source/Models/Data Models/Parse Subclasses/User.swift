//
//  User.swift
//  Benji
//
//  Created by Benji Dodgson on 11/2/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse

enum UserKey: String {
    case email
    case reservation
    case connections
    case people
    case handle
    case me
    case phoneNumber
}

class User: PFUser {

    static var current = User.current()!

    private(set) var me: Person?

    var handle: String? {
        get {
            guard let handle: String = self.getObject(for: .handle) else { return nil }
            return "@" + handle.lowercased()
        }
        set {
            self.setObject(for: .handle, with: newValue)
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

    private(set) var reservation: Reservation? {
        get {
            return self.getObject(for: .reservation)
        }
        set {
            self.setObject(for: .reservation, with: newValue)
        }
    }

    var connections: [Conneciton] {
        get {
            return self.getObject(for: .connections) ?? []
        }
        set {
            self.setObject(for: .connections, with: newValue)
        }
    }

    var people: [Person] {
        get {
            return self.getObject(for: .people) ?? []
        }
        set {
            self.setObject(for: .people, with: newValue)
        }
    }
}

extension User: Objectable {
    typealias KeyType = UserKey

    func getObject<Type>(for key: UserKey) -> Type? {
        return self.object(forKey: key.rawValue) as? Type
    }

    func setObject<Type>(for key: UserKey, with newValue: Type) {
        self.setObject(newValue, forKey: key.rawValue)
    }

    func getRelationalObject<PFRelation>(for key: UserKey) -> PFRelation? {
        return self.relation(forKey: key.rawValue) as? PFRelation
    }
}

extension User {

    func createHandle() {
        guard let me = self.me,
            let first = me.givenName?.first,
            let last = me.familyName?.first,
            let position = self.reservation?.position else { return } //Change to reservation count

        self.handle = String(first) + String(last) + "_" + String(position)
    }
}
