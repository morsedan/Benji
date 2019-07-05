//
//  Future.swift
//  Benji
//
//  Created by Benji Dodgson on 7/5/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

// A wrapper object that will contain a value at some time in the future.
// The contained value is intentionally not directly accessible. Interested parties can be notified when
// the value is set by assigning a callback through the observe function.
class Future<Value> {

    fileprivate var result: Result<Value, Error>? {
        didSet {
            // Report a result whenever it is assigned
            if let result = self.result {
                self.report(result: result)
            }
        }
    }
    private lazy var callbacks = [(Result<Value, Error>) -> Void]()

    func observe(with callback: @escaping (Result<Value, Error>) -> Void) {
        self.callbacks.append(callback)

        // If a result has already been set, call the callback directly
        if let result = self.result {
            callback(result)
        }
    }

    private func report(result: Result<Value, Error>) {
        self.callbacks.forEach { (callback) in
            callback(result)
        }
    }
}

// A future value that can be fulfilled. Promises are a subclass of futures that allow you to set the
// result or pass in an error, thus alerting any observers.
class Promise<Value>: Future<Value> {

    init(value: Value? = nil) {
        super.init()

        // If the value was already known at the time the promise was constructed,
        // we can report the value directly
        if let value = value {
            self.result = Result.success(value)
        }
    }

    init(error: Error) {
        super.init()
        self.result = Result.failure(error)
    }

    func resolve(with value: Value) {
        self.result = .success(value)
    }

    func reject(with error: Error) {
        self.result = .failure(error)
    }
}
