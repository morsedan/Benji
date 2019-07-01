//
//  MathFunctions.swift
//  Benji
//
//  Created by Benji Dodgson on 6/30/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

func pow(_ lhs: Int, _ rhs: Int) -> Int {
    return Int(powf(Float(lhs), Float(rhs)))
}

func clamp(_ value: CGFloat, _ min: CGFloat, _ max: CGFloat) -> CGFloat {
    return (min...max).clamp(value)
}

func clamp(_ value: CGFloat, min: CGFloat) -> CGFloat {
    return (min...CGFloat.infinity).clamp(value)
}

func clamp(_ value: CGFloat, max: CGFloat) -> CGFloat {
    return (-CGFloat.infinity...max).clamp(value)
}

// Linearly interpolate between two values given a normalized value between 0 and 1
// Example: lerp(0.2, min 1, max 3) = 1.4
func lerp(_ normalized: CGFloat, min: CGFloat, max: CGFloat) -> CGFloat {
    return min + normalized * (max - min)
}

// Linearly interpolate between two values. The normalized value is clamped between 0 and 1 so
// the result will never be outside the range of the min and max
func lerpClamped(_ normalized: CGFloat, min: CGFloat, max: CGFloat) -> CGFloat {
    return lerp((0...1).clamp(normalized), min: min, max: max)
}
