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
import TMROFutures

protocol CloudFunction {
    associatedtype ReturnType

    func makeRequest() -> Future<ReturnType>
}

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

struct VerifyReservation: CloudFunction {

    let code: String

    func makeRequest() -> Future<Reservation> {
        let promise = Promise<Reservation>()

        let params: [String: Any] = ["code": self.code]

        PFCloud.callFunction(inBackground: "verifyReservation",
                             withParameters: params) { (object, error) in
                                if let error = error {
                                    promise.reject(with: error)
                                } else if let reservation = object as? Reservation {
                                    promise.resolve(with: reservation)
                                } else {
                                    promise.reject(with: ClientError.generic)
                                }
        }

        return promise.withResultToast()
    }
}

struct SendPush: CloudFunction {

    let code: String

    func makeRequest() -> Future<Reservation> {
        let promise = Promise<Reservation>()

        let params: [String: Any] = ["code": self.code]

        PFCloud.callFunction(inBackground: "verifyReservation",
                             withParameters: params) { (object, error) in
                                if let error = error {
                                    promise.reject(with: error)
                                } else if let reservation = object as? Reservation {
                                    promise.resolve(with: reservation)
                                } else {
                                    promise.reject(with: ClientError.generic)
                                }
        }

        return promise.withResultToast()
    }
}
