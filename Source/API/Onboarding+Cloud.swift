//
//  Onboarding+CloudCalls.swift
//  Benji
//
//  Created by Benji Dodgson on 2/11/20.
//  Copyright © 2020 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse
import TMROFutures
import PhoneNumberKit

struct SendCode: CloudFunction {
    let phoneNumber: PhoneNumber

    func makeRequest() -> Future<Void> {
        let promise = Promise<Void>()

        PFCloud.callFunction(inBackground: "sendCode",
                             withParameters: ["phoneNumber": PhoneKit.shared.format(self.phoneNumber, toType: .e164)]) { (object, error) in
                                if let error = error {
                                    promise.reject(with: error)
                                } else {
                                    promise.resolve(with: ())
                                }
        }

        return promise.withResultToast()
    }
}

struct VerifyCode: CloudFunction {

    let code: String
    let phoneNumber: PhoneNumber

    func makeRequest() -> Future<String> {
        let promise = Promise<String>()

        let params: [String: Any] = ["authCode": self.code,
                                     "phoneNumber": PhoneKit.shared.format(self.phoneNumber, toType: .e164)]

        PFCloud.callFunction(inBackground: "validateCode",
                             withParameters: params) { (object, error) in
                                if let error = error {
                                    promise.reject(with: error)
                                } else if let token = object as? String {
                                    promise.resolve(with: token)
                                }
        }

        return promise.withResultToast()
    }
}
