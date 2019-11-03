//
//  Person+Objectable.swift
//  Benji
//
//  Created by Benji Dodgson on 11/3/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

extension Person: Objectable {
    typealias KeyType = PersonKey

    func getObject<Type>(for key: PersonKey) -> Type? {
        return self.object(forKey: key.rawValue) as? Type
    }

    func getRelationalObject<Type>(for key: PersonKey) -> Type? {
        return self.relation(forKey: key.rawValue) as? Type
    }

    func setObject<Type>(for key: PersonKey, with newValue: Type) {
        self.setObject(newValue, forKey: key.rawValue)
    }

    func saveObject() -> Future<Person> {
        let promise = Promise<Person>()

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
