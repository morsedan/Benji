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
    
    var initials: String {
        return String(optional: self.user?.initials)
    }

    var firstName: String {
        return String(optional: self.user?.firstName)
    }

    var lastName: String {
        return String(optional: self.user?.lastName)
    }

    var handle: String {
        return String(optional: self.user?.handle)
    }

    var userObjectID: String? {
        return self.identity
    }

    var user: PFUser? {
        return nil 
    }

    var photo: UIImage? {
        return self.user?.photo
    }
}

extension Future where Value == TCHMember {

    func getMemberAsUser() -> Future<PFUser> {
        return self.then(with: { (member) in
            let promise = Promise<PFUser>()
            if let authorID = member.identity {
                PFUser.cachedQuery(for: authorID, completion: { (object, error) in
                    if let error = error {
                        promise.reject(with: error)
                    } else if let user = object as? PFUser {
                        promise.resolve(with: user)
                    } else {
                        promise.reject(with: ClientError.generic)
                    }
                })
            } else {
                promise.reject(with: ClientError.generic)
            }

            return promise
        })
    }
}

