//
//  Reservation+CloudCalls.swift
//  Benji
//
//  Created by Benji Dodgson on 2/11/20.
//  Copyright © 2020 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TMROFutures
import Parse

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
                                    promise.reject(with: ClientError.message(detail: "The object returned from PFCloud.callFunction was not of type Reservation"))
                                }
        }

        return promise.withResultToast()
    }
}
