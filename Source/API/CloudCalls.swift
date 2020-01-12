//
//  CloudCalls.swift
//  Benji
//
//  Created by Benji Dodgson on 9/10/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse
import PhoneNumberKit

protocol CloudFunction {
    func callFunction(completion: PFIdResultBlock?)
}

struct SendCode: CloudFunction {
    let phoneNumber: PhoneNumber

    func callFunction(completion: PFIdResultBlock?) {
        PFCloud.callFunction(inBackground: "sendCode",
                             withParameters: ["phoneNumber": PhoneKit.shared.format(self.phoneNumber, toType: .e164)],
                             block: completion)
    }
}

struct VerifyCode: CloudFunction {
    let code: String
    let phoneNumber: PhoneNumber

    func callFunction(completion: PFIdResultBlock?) {
        let params: [String: Any] = ["authCode": self.code,
                                     "phoneNumber": PhoneKit.shared.format(self.phoneNumber, toType: .e164)]
        PFCloud.callFunction(inBackground: "validateCode",
                             withParameters: params,
                             block: completion)
    }
}
