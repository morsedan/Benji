//
//  TimeHump.swift
//  Benji
//
//  Created by Martin Young on 8/27/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class TimeHumpView: View {

    var amplitude: CGFloat {
        return self.height * 0.5
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let path = UIBezierPath()
        path.move(to: CGPoint())

        for percentage in stride(from: 0, through: 1.0, by: 0.01) {
            let point = self.getPoint(normalizedX: CGFloat(percentage))
            path.addLine(to: point)
        }

        UIColor.black.setStroke()
        path.stroke()
    }

    func getPoint(normalizedX: CGFloat) -> CGPoint {

        let angle = normalizedX * twoPi

        let x = self.width * normalizedX
        let y = (self.height * 0.5) - (sin(angle - halfPi) * self.amplitude)

        return CGPoint(x: x, y: y)
    }
}

let halfPi: CGFloat = CGFloat.pi * 05
let twoPi: CGFloat = CGFloat.pi * 2

func sin(degrees: Double) -> Double {
    return __sinpi(degrees/180.0)
}

func sin(degrees: Float) -> Float {
    return __sinpif(degrees/180.0)
}

func sin(degrees: CGFloat) -> CGFloat {
    return CGFloat(sin(degrees: degrees.native))
}
