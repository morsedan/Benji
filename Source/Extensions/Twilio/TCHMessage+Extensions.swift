//
//  TCHMessages+Extensions.swift
//  Benji
//
//  Created by Benji Dodgson on 2/3/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient
import Parse

extension TCHMessage: ManageableCellItem, Avatar {

    var id: String {
        return self.sid!
    }

    var backgroundColor: Color {
        get {
            return self.isFromCurrentUser ? .purple : .lightPurple
        }
    }

    var isFromCurrentUser: Bool {
        guard let author = self.author,
            let identity = PFUser.current()?.objectId else { return false }
        return author == identity
    }

    var givenName: String {
        return String()
    }

    var familyName: String {
        return String()
    }

    var image: UIImage? {
        return nil
    }

    var userObjectID: String? {
        return self.author
    }

    var status: MessageTypeStatus {
        return .delivered
    }
}

extension TCHMessage {

    func getAuthorAsUser() -> Future<User> {
        let promise = Promise<User>()
        if let authorID = self.author {
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
