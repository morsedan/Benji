//
//  CGPoint+Extensions.swift
//  Benji
//
//  Created by Benji Dodgson on 12/29/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

extension CGPoint {

    func floored() -> CGPoint {
        return CGPoint(x: floor(x), y: floor(y))
    }

    mutating func flooredInPlace() {
        self = self.floored()
    }
}
