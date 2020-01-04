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

    static func cachedQuery(for objectID: String) -> Future<Self>
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
}
