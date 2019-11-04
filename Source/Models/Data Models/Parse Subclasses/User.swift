//
//  User.swift
//  Benji
//
//  Created by Benji Dodgson on 11/2/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse

enum ObjectKey: String {
    case objectId
    case createAt
    case updatedAt
}

enum UserKey: String {
    case email
    case reservation
    case connections
    case person
    case people
    case handle
    case me
    case phoneNumber
}

final class User: PFUser {

    static var me = User.current()?.person

    var person: Person? {
        get {
            return self.getObject(for: .person)
        }
        set {
            self.setObject(for: .person, with: newValue)
        }
    }

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
