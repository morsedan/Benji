//
//  User+Extensions.swift
//  Benji
//
//  Created by Benji Dodgson on 11/3/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse
import TMROFutures

extension User: Avatar {

    var userObjectID: String? {
        self.objectId
    }

    var image: UIImage? {
        return nil
    }

    var isOnboarded: Bool {
        if self.handle == nil {
            return false
        } else if self.smallImage == nil {
            return false
        }

        return true 
    }
}

extension User {

    func getRoutine() -> Future<Routine> {
        let promise = Promise<Routine>()

        if let routine = self.routine {
            if routine.isDataAvailable {
                promise.resolve(with: routine)
            } else {
                self.routine?.fetchInBackground(block: { (object, error) in
                    runMain {
                        if let routine = object as? Routine {
                            promise.resolve(with: routine)
                        } else if let error = error {
                            promise.reject(with: error)
                        }
                    }
                })
            }
        } else {
            promise.reject(with: ClientError.generic)
        }

        return promise
    }

    func createHandle() {
        guard let current = User.current(),
            !current.givenName.isEmpty,
            let last = current.familyName.first,
            let position = self.reservation?.position else { return } 
        var positionString = String(position)
        let start = positionString.startIndex
        let end = positionString.index(positionString.startIndex, offsetBy: 1)
        positionString = positionString.replacingCharacters(in: start...end, with: "")
        let handleString = String(current.givenName) + String(last) + "_" + positionString
        self.handle = handleString.lowercased()
    }
}

extension User: ManageableCellItem {
    var id: String {
        return self.objectId!
    }
}

extension User {
    
    func formatName(from text: String) {
        let components = text.components(separatedBy: " ").filter { (component) -> Bool in
            return !component.isEmpty
        }
        if let first = components.first {
            self.givenName = first
        }
        if let last = components.last {
            self.familyName = last
        }
    }
}
