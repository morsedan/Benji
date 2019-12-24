//
//  FeedType.swift
//  Benji
//
//  Created by Benji Dodgson on 6/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient

enum FeedType {
    case intro
    case rountine
    case system(SystemMessage)
    case unreadMessages(TCHChannel, Int)
    case channelInvite(TCHChannel)
    case inviteAsk
    case notificationPermissions
}
