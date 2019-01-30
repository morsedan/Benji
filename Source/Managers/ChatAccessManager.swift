//
//  ChatAccessManager.swift
//  Benji
//
//  Created by Benji Dodgson on 1/29/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioAccessManager

class AccessManager:NSObject, TwilioAccessManagerDelegate {

    static var shared = AccessManager()
    var client: TwilioAccessManager?

    func login(withToken token: String!, completion: @escaping CompletionHandler) {

        self.client = TwilioAccessManager.init(token: token, delegate: self as TwilioAccessManagerDelegate)
        ChannelManager.shared.initialize(token: token) { [weak self] (client, error) in
            guard let `self` = self else { return }
            if let chatClient = client {
                self.client?.registerClient(chatClient, forUpdates: { (updatedToken) in
                    ChannelManager.shared.update(token: updatedToken, completion: completion)
                })
            }
        }
    }

    func shutdown() {

    }

    func accessManagerTokenWillExpire(_ accessManager: TwilioAccessManager) {

    }

    func accessManagerTokenExpired(_ accessManager: TwilioAccessManager) {

    }

    func accessManagerTokenInvalid(_ accessManager: TwilioAccessManager) {

    }
}
