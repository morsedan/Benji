//
//  CloudCalls.swift
//  Benji
//
//  Created by Benji Dodgson on 9/10/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse

protocol CloudFunction {
    static func callFunction(completion: PFIdResultBlock?)
}

struct SendCode: CloudFunction {
    static func callFunction(completion: PFIdResultBlock?) {
        PFCloud.callFunction(inBackground: "sendCode", withParameters: nil, block: completion)
    }
}

struct VerifyCode: CloudFunction {
    static func callFunction(completion: PFIdResultBlock?) {
        PFCloud.callFunction(inBackground: "validateCode", withParameters: nil, block: completion)
    }
}
