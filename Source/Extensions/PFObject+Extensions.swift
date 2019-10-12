//
//  PFObject+Extensions.swift
//  Benji
//
//  Created by Benji Dodgson on 9/11/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse

extension PFObject {

    func userObject<Type>(for key: UserKey) -> Type? {
        return self.object(forKey: key.rawValue) as? Type
    }

    func setUserObject<Type>(for key: UserKey, with newValue: Type) {
        self.setObject(newValue, forKey: key.rawValue)
    }

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
