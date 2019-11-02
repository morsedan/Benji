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

class Reservation: Object {

    var position: Int? {
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
}
