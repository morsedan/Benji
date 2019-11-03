//
//  PFObject+Extensions.swift
//  Benji
//
//  Created by Benji Dodgson on 9/11/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse

protocol Subclassing: PFSubclassing {}

extension Subclassing {
    static func parseClassName() -> String {
        return String(describing: self)
    }
}

protocol Objectable: class {
    associatedtype KeyType

    func getObject<Type>(for key: KeyType) -> Type?
    func getRelationalObject<PFRelation>(for key: KeyType) -> PFRelation?
    func setObject<Type>(for key: KeyType, with newValue: Type)
    func saveObject() -> Future<PFObject>
}

extension PFObject {

    func saveObject() -> Future<PFObject> {

        let promise = Promise<PFObject>()

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
