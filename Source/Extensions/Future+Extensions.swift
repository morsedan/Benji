//
//  Future+Extensions.swift
//  Benji
//
//  Created by Benji Dodgson on 7/5/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

extension Future {

    // Converts this future into a void future. Can be used to combine futures of differing types.
    // FIX: THIS DOESN'T COMPILE
    //    func asVoid() -> Future<Void> {
    //        return then(with: { _ in
    //            return ()
    //        })
    //    }

    // Executes the passed in callback after this future receives its result.
    func then<NextValue>(with callback: @escaping (Value) -> Future<NextValue>) -> Future<NextValue> {

        // A promise that will be fullfilled once the callback's future is fulfilled
        let promise = Promise<NextValue>()

        // When this future gets a result, we'll execute the callback
        self.observe { result in

            switch result {
            case .success(let value):

                // Once the callback finishes its task, our original promise will be resolved or rejected
                let future: Future<NextValue> = callback(value)
                future.observe { result in
                    switch result {
                    case .success(let value):
                        promise.resolve(with: value)
                    case .failure(let error):
                        promise.reject(with: error)
                    }
                }
            case .failure(let error):
                promise.reject(with: error)
            }
        }

        return promise
    }

    // After a future is fulfilled, the transformation closure is applied to the resulting value.
    // The newly transformed value can then be use as input for another future operation.
    func transform<NextValue>(with closure: @escaping (Value) -> NextValue) -> Future<NextValue> {
        return self.then(with: { (value) in
            return Promise(value: closure(value))
        })
    }
}
