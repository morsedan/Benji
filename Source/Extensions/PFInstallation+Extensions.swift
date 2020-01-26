//
//  PFInstallation+Extensions.swift
//  Benji
//
//  Created by Benji Dodgson on 1/26/20.
//  Copyright © 2020 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse
import TMROFutures

extension PFInstallation {

    func saveToken() -> Future<Void> {
        let promise = Promise<Void>()
        if let current = User.current() {
            self["user"] = current
            self.saveInBackground { (success, error) in
                if success {
                    promise.resolve(with: ())
                } else if let error = error {
                    promise.reject(with: error)
                } else {
                    promise.reject(with: ClientError.generic)
                }
            }
        } else {
            promise.reject(with: ClientError.generic)
        }

        return promise.withResultToast()
    }
}
