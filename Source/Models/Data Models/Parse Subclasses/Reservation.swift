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

    private(set) var position: Double? {
        get {
            return self.getObject(for: .position)
        }
        set {
            self.setObject(for: .position, with: newValue)
        }
    }

    static func create() -> Future<Reservation> {
        let promise = Promise<Reservation>()

        let query = PFQuery.init(className: "ReservationCount")
        query.getObjectInBackground(withId: "DVfDrd0gWq") { (object, error) in
            if let current = object {
                current.incrementKey(ReservationCountKeys.currentCount.rawValue, byAmount: 1)
                current.saveInBackground { (success, error) in
                    if success {
                        let reservation = Reservation()
                        let count = current["currentCount"] as! NSNumber
                        let cap = current["cap"] as! NSNumber
                        let position: Double = Double(truncating: count) / Double(truncating: cap)
                        reservation.position = position.rounded(by: cap.intValue)
                        reservation.saveEventually()
                            .observe { (result) in
                                switch result {
                                case .success(let updatedReservation):
                                    promise.resolve(with: updatedReservation)
                                case .failure(let error):
                                    promise.reject(with: error)
                                }
                        }
                    } else if let error = error {
                        promise.reject(with: error)
                    } else {
                        promise.reject(with: ClientError.generic)
                    }
                }
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
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }

    func rounded(by value: Int) -> Double {
        return (self * Double(value)).rounded() / Double(value)
    }
}
