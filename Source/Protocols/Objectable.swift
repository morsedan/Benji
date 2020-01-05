//
//  Objectable.swift
//  Benji
//
//  Created by Benji Dodgson on 11/3/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse

protocol Objectable: class {
    associatedtype KeyType

    func getObject<Type>(for key: KeyType) -> Type?
    func getRelationalObject<PFRelation>(for key: KeyType) -> PFRelation?
    func setObject<Type>(for key: KeyType, with newValue: Type)
    func saveEventually() -> Future<Self>
    func save() -> Future<Self>

    static func localThenNetworkQuery(for objectId: String) -> Future<Self>
    static func cachedArrayQuery(with identifiers: [String]) -> Future<[Self]>
    static func cachedArrayQuery(notEqualTo identifier: String) -> Future<[Self]>
}

extension Objectable {

    static func cachedQuery(for objectID: String) -> Future<Self> {
        return Promise<Self>()
    }

    static func cachedArrayQuery(with identifiers: [String]) -> Future<[Self]> {
        return Promise<[Self]>()
    }

    static func cachedArrayQuery(notEqualTo identifier: String) -> Future<[Self]> {
        return Promise<[Self]>()
    }
}

extension Objectable where Self: PFObject {

    // Will save the object locally and push up to the server when ready
    func saveEventually() -> Future<Self> {
        let promise = Promise<Self>()
        self.saveEventually { (success, error) in
            if let error = error {
                promise.reject(with: error)
            } else {
                promise.resolve(with: self)
            }
        }
        return promise
    }

    // Does not save locally but just pushes to server in the background
    func save() -> Future<Self> {
        let promise = Promise<Self>()
        self.saveInBackground { (success, error) in
            if let error = error {
                promise.reject(with: error)
            } else {
                promise.resolve(with: self)
            }
        }
        return promise
    }

    static func localThenNetworkQuery(for objectId: String) -> Future<Self> {
        let objectTask = BFTaskCompletionSource<Self>()

        if let query = self.query() {
            query.fromPin(withName: objectId)
            query.getFirstObjectInBackground()
                .continueWith { (task) -> Any? in
                if let object = task.result as? Self {
                    objectTask.set(result: object)
                } else if let nonCacheQuery = self.query() {
                    nonCacheQuery.whereKey(ObjectKey.objectId.rawValue, equalTo: objectId)
                    nonCacheQuery.getFirstObjectInBackground { (object, error) in
                        if let nonCachedObject = object as? Self, let identifier = nonCachedObject.objectId {
                            nonCachedObject.pinInBackground(withName: identifier) { (success, error) in
                                if let error = error {
                                    objectTask.set(error: error)
                                } else {
                                    objectTask.set(result: nonCachedObject)
                                }
                            }
                        } else if let error = error {
                            objectTask.set(error: error)
                        } else {
                            objectTask.set(error: ClientError.generic)
                        }
                    }
                } else {
                    return objectTask.set(error: ClientError.generic)
                }
                return objectTask
            }
        }

        let promise = Promise<Self>()
        objectTask.task
            .continueWith { (task) -> Any? in
                if let object = task.result {
                    promise.resolve(with: object)
                } else if let error = task.error {
                    promise.reject(with: error)
                } else {
                    promise.reject(with: ClientError.generic)
                }
                return nil
        }

        return promise
    }
}
