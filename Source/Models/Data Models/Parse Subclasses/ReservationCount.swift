//
//  ReservationCount.swift
//  Benji
//
//  Created by Benji Dodgson on 11/9/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse

enum ReservationCountKeys: String {
    case cap
    case currentCount
}

final class ReservationCount: PFObject, PFSubclassing {
    
    static func parseClassName() -> String {
        return String(describing: self)
    }


    private(set) var current: Int? {
        get { return self.getObject(for: .currentCount) }
        set { self.setObject(for: .currentCount, with: newValue) }
    }

    private(set) var cap: Int? {
        get { return self.getObject(for: .cap) }
        set { self.setObject(for: .cap, with: newValue) }
    }
}

extension ReservationCount: Objectable {
    typealias KeyType = ReservationCountKeys

    func getObject<Type>(for key: ReservationCountKeys) -> Type? {
        self.object(forKey: key.rawValue) as? Type
    }

    func setObject<Type>(for key: ReservationCountKeys, with newValue: Type) {
        self.setObject(newValue, forKey: key.rawValue)
    }

    func getRelationalObject<PFRelation>(for key: ReservationCountKeys) -> PFRelation? {
        return self.relation(forKey: key.rawValue) as? PFRelation
    }
}
