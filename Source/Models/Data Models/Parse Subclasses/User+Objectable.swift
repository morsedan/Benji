//
//  User+Objectable.swift
//  Benji
//
//  Created by Benji Dodgson on 11/3/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse

extension User: Objectable {
    typealias KeyType = UserKey

    static func cachedTaskQuery(for objectID: String) -> BFTask<User> {
        let userTask = BFTaskCompletionSource<User>()

        // update to use pin
        if let query = self.query() {
            query.fromLocalDatastore()
            query.whereKey(ObjectKey.objectId.rawValue, equalTo: objectID)
            query.getFirstObjectInBackground()
                .continueWith { (task) -> Any? in
                if let user = task.result as? User {
                    userTask.set(result: user)
                } else if let nonCacheQuery = self.query() {
                    nonCacheQuery.whereKey(ObjectKey.objectId.rawValue, equalTo: objectID)
                    nonCacheQuery.getFirstObjectInBackground { (object, error) in
                        if let user = object as? User {
                            user.pinInBackground { (success, error) in
                                if let error = error {
                                    userTask.set(error: error)
                                } else {
                                    userTask.set(result: user)
                                }
                            }
                        } else if let error = error {
                            userTask.set(error: error)
                        } else {
                            userTask.set(error: ClientError.generic)
                        }
                    }
                } else {
                    return userTask.set(error: ClientError.generic)
                }
                return userTask
            }
        }

        return userTask.task
    }

    static func cachedArrayQuery(with identifiers: [String]) -> Future<[User]> {
        let promise = Promise<[User]>()

        //Udpate to use pin
        if let query = self.query() {
            query.whereKey(ObjectKey.objectId.rawValue, containedIn: identifiers)
            query.findObjectsInBackground { (objects, error) in
                if let objs = objects as? [User] {
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

    static func initializeArrayQuery(notEqualTo identifier: String,
                                     cachePolicy: PFCachePolicy = .cacheThenNetwork) -> Future<[User]> {
        
        let promise = Promise<[User]>()

        //Update to use pin
        if let query = self.query() {
            query.whereKey(ObjectKey.objectId.rawValue, notEqualTo: identifier)
            query.findObjectsInBackground { (objects, error) in
                if let objs = objects as? [User] {
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


    func getObject<Type>(for key: UserKey) -> Type? {
        return self.object(forKey: key.rawValue) as? Type
    }

    func setObject<Type>(for key: UserKey, with newValue: Type) {
        self.setObject(newValue, forKey: key.rawValue)
    }

    func getRelationalObject<PFRelation>(for key: UserKey) -> PFRelation? {
        return self.relation(forKey: key.rawValue) as? PFRelation
    }
}
