//
//  Conneciton.swift
//  Benji
//
//  Created by Benji Dodgson on 11/2/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse

enum ConnectionKey: String {
    case status
    case userId
    case channels
}

final class Conneciton: PFObject, PFSubclassing {

    static func parseClassName() -> String {
        return String(describing: self)
    }

    enum Status: String {
        case pending
        case accepted
        case declined
    }

    var status: Status? {
        get {
            guard let string: String = self.getObject(for: .status) else { return nil }
            return Status(rawValue: string)
        }
        set {
            self.setObject(for: .status, with: newValue?.rawValue)
        }
    }

    var userId: String? {
        get {
            return self.getObject(for: .userId)
        }
        set {
            self.setObject(for: .userId, with: newValue)
        }
    }

    var channels: [String]? {
        get {
            return self.getObject(for: .channels)
        }
        set {
            self.setObject(for: .channels, with: newValue)
        }
    }
}

extension Conneciton: Objectable {
    typealias KeyType = ConnectionKey

    func getObject<Type>(for key: ConnectionKey) -> Type? {
        return self.object(forKey: key.rawValue) as? Type
    }

    func setObject<Type>(for key: ConnectionKey, with newValue: Type) {
        self.setObject(newValue, forKey: key.rawValue)
    }

    func getRelationalObject<PFRelation>(for key: ConnectionKey) -> PFRelation? {
        return self.relation(forKey: key.rawValue) as? PFRelation
    }

    func saveObject() -> Future<Conneciton> {
        let promise = Promise<Conneciton>()

        self.saveInBackground { (success, error) in
            if let error = error {
                promise.reject(with: error)
            } else {
                promise.resolve(with: self)
            }
        }

        return promise
    }
}