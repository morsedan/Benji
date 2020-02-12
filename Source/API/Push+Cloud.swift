//
//  Push+CloudCalls.swift
//  Benji
//
//  Created by Benji Dodgson on 2/11/20.
//  Copyright © 2020 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse
import TMROFutures

struct SendPush: CloudFunction {

    var user: User

    func makeRequest() -> Future<Void> {
        let promise = Promise<Void>()

        PFCloud.callFunction(inBackground: "sendPush",
                             withParameters: ["user": user]) { (object, error) in
                                if let error = error {
                                    promise.reject(with: error)
                                } else {
                                    promise.resolve(with: ())
                                }
        }

        return promise.withResultToast()
    }
}
