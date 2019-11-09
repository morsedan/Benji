//
//  Future+Extensions.swift
//  Benji
//
//  Created by Benji Dodgson on 7/5/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TMROFutures

extension Future {

    @discardableResult
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

    func ignoreUserInteractionEventsUntilDone() -> Future<Value> {
        UIApplication.shared.beginIgnoringInteractionEvents()

        self.observe { (result) in
            UIApplication.shared.endIgnoringInteractionEvents()
        }

        return self
    }

    func withProgressBanner(_ text: String) -> Future<Value> {
        print(text)
        //Add banner
        //let banner = TomorrowBanner.showProgress(text)
        let start = Date()

        self.observe { (result) in
            switch result {
            case .success:
                // Minimum display time of 1 second
                let elapsed: Double = Date().timeIntervalSince(start)

                if elapsed < 1 {
                    delay(1 - elapsed) {
                       // banner.dismiss()
                    }
                } else {
                    //banner.dismiss()
                }
            case .failure:
                break 
                //banner.dismiss()
            }
        }

        return self
    }

    func withErrorBanner() -> Future<Value> {

        self.observe { (result) in
            switch result {
            case .success:
                break
            case .failure(let error):
                let message: String
                if let error = error as? ClientError {
                    message = error.localizedDescription
                } else {
                    message = error.localizedDescription
                }

                print(message)
                //Add banner
            }
        }

        return self
    }
}
