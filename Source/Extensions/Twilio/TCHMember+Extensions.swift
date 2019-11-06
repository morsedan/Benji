//
//  TCHMember+Extensions.swift
//  Benji
//
//  Created by Benji Dodgson on 9/14/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient
import Parse

extension TCHMember: Avatar {

    var givenName: String {
        return String()
    }

    var familyName: String {
        return String()
    }

    var handle: String? {
        return nil
    }

    var image: UIImage? {
        return nil
    }

    var userObjectID: String? {
        return self.identity
    }
}

extension TCHMember {
    func getMemberAsUser() -> Future<User> {

        let promise = Promise<User>()
        if let authorID = self.identity {
            User.cachedQuery(for: authorID)
                .observe { (result) in
                    switch result {
                    case .success(let user):
                        promise.resolve(with: user)
                    case .failure(let error):
                        promise.reject(with: error)
                    }
            }
        } else {
            promise.reject(with: ClientError.generic)
        }

        return promise
    }
}

