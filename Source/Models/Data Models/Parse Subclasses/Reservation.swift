//
//  Reservation.swift
//  Benji
//
//  Created by Benji Dodgson on 11/2/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse

enum ReservationKeys: String {
    case position
}

final class Reservation: PFObject, PFSubclassing {

    static func parseClassName() -> String {
        return String(describing: self)
    }

    private(set) var position: Int? {
        get {
            return self.getObject(for: .position)
        }
        set {
            self.setObject(for: .position, with: newValue)
        }
    }

    static func create() -> Future<Reservation> {
        let promise = Promise<Reservation>()

        let currentCount = PFObject.init(className: "ReservationCount")
        currentCount.incrementKey("currentCount", byAmount: 1)
        currentCount.saveInBackground { (success, error) in
            if success {

            } else if let error = error {
                promise.reject(with: error)
            } else {
                promise.reject(with: ClientError.generic)
            }
        }

        return promise
    }
}

extension Reservation: Objectable {
    typealias KeyType = ReservationKeys

    func getObject<Type>(for key: ReservationKeys) -> Type? {
        self.object(forKey: key.rawValue) as? Type
    }

    func setObject<Type>(for key: ReservationKeys, with newValue: Type) {
        self.setObject(newValue, forKey: key.rawValue)
    }

    func getRelationalObject<PFRelation>(for key: ReservationKeys) -> PFRelation? {
        return self.relation(forKey: key.rawValue) as? PFRelation
    }

    func saveObject() -> Future<Reservation> {
        let promise = Promise<Reservation>()

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
