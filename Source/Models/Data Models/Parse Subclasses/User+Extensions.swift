//
//  User+Extensions.swift
//  Benji
//
//  Created by Benji Dodgson on 11/3/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse

extension User: Avatar {

    var givenName: String {
        return String(optional: self.person?.givenName)
    }

    var familyName: String {
        return String(optional: self.person?.familyName)
    }

    var userObjectID: String? {
        self.objectId
    }

    var image: UIImage? {
        return nil
    }
}

extension User {

    func createHandle() {
        guard let me = User.me,
            let first = me.givenName.first,
            let last = me.familyName.first,
            let position = self.reservation?.position else { return } //Change to reservation count

        self.handle = String(first) + String(last) + "_" + String(position)
    }

    static func anonymousLogin() -> Future<User> {
        let promise = Promise<User>()
        PFAnonymousUtils.logIn { (user, error) in
            if let anonymousUser = user as? User {
                self.createMePerson(for: anonymousUser)
                    .observe { (result) in
                        switch result {
                        case .success:
                            promise.resolve(with: anonymousUser)
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
        return promise 
    }

    private static func createMePerson(for user: User) -> Future<Void> {
        let promise = Promise<Void>()
        user.person = Person()
        user.saveObject()
            .observe { (result) in
                switch result {
                case .success(_):
                    promise.resolve(with: ())
                case .failure(let error):
                    promise.reject(with: error)
                }
        }
        return promise
    }
}

extension User: DisplayableCellItem {

    var backgroundColor: Color {
        return .red
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self.objectId! as NSObjectProtocol
    }
}
