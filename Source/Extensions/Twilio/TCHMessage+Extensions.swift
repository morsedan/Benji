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
import TMROLocalization

extension TCHMessage: Avatar {

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
}

extension TCHMessage: Messageable {

    var id: String {
        return self.sid!
    }

    var isFromCurrentUser: Bool {
        guard let author = self.author,
            let identity = PFUser.current()?.objectId else { return false }
        return author == identity
    }

    var createdAt: Date {
        return self.timestampAsDate ?? Date()
    }

    var text: Localized {
        return String(optional: self.body)
    }

    var authorID: String {
        return String(optional: self.author)
    }

    var messageIndex: NSNumber? {
        return self.index
    }

    var attributes: [String : Any]? {
        return self.attributes()
    }

    var avatar: Avatar {
        return self
    }

    var status: MessageStatus {
        if let statusString = self.attributes()?["status"] as? String, let type = MessageStatus(rawValue: statusString) {
            return type
        }

        return .unknown
    }

    func updateTo(status: MessageStatus) -> Future<Void> {
        let promise = Promise<Void>()
        var mutableAttributes: [String: Any] = self.attributes() ?? [:]
        mutableAttributes["status"] = status.rawValue
        self.setAttributes(mutableAttributes) { (result) in
            if let error = result.error {
                promise.reject(with: error)
            } else {
                promise.resolve(with: ())
            }
        }

        return promise 
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
