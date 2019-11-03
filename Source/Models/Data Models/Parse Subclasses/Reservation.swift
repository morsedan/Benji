//
//  Reservation.swift
//  Benji
//
//  Created by Benji Dodgson on 11/2/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

enum ReservationKeys: String {
    case position
}

final class Reservation: Object {
    private(set) var position: Int? {
        get {
            return self.getObject(for: .position)
        }
        set {
            self.setObject(for: .position, with: newValue)
        }
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
