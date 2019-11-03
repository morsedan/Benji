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

    static func cachedQuery(for objectID: String) -> Future<PFObject> {
        let promise = Promise<PFObject>()

        if let query = self.query() {
            query.cachePolicy = .cacheThenNetwork
            query.whereKey(ObjectKey.objectId.rawValue, equalTo: objectID)
            query.getFirstObjectInBackground { (object, error) in
                if let obj = object {
                    promise.resolve(with: obj)
                } else if let error = error {
                    promise.reject(with: error)
                } else {
                    promise.reject(with: ClientError.generic)
                }
            }
        }

        return promise
    }

    static func cachedArrayQuery(with identifiers: [String]) -> Future<[PFObject]> {
        let promise = Promise<[PFObject]>()

        if let query = self.query() {
            query.cachePolicy = .cacheThenNetwork
            query.whereKey(ObjectKey.objectId.rawValue, containedIn: identifiers)
            query.findObjectsInBackground { (objects, error) in
                if let objs = objects {
                    promise.resolve(with: objs)
                } else if let error = error {
                    promise.reject(with: error)
                } else {
                    promise.reject(with: ClientError.generic)
                }
            }
        }

        return promise
    }
}
