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
    case handle
    case phoneNumber
    case givenName
    case familyName
    case smallImage
    case largeImage
}

final class User: PFUser {

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

    var givenName: String {
        get {
            return String(optional: self.getObject(for: .givenName))
        }
        set {
            self.setObject(for: .givenName, with: newValue)
        }
    }

    var familyName: String {
        get {
            return String(optional: self.getObject(for: .familyName))
        }
        set {
            self.setObject(for: .familyName, with: newValue)
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
}
