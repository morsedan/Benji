//
//  TimeHump.swift
//  Benji
//
//  Created by Martin Young on 8/27/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class TimeHumpView: View {

    let graphWidth: CGFloat = 1
    let amplitude: CGFloat = 0.5

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let width = rect.width
        let height = rect.height

        let origin = CGPoint(x: width * (1 - graphWidth) / 2, y: height * 0.50)

        let path = UIBezierPath()
        path.move(to: origin)

        for angle in stride(from: 0, through: 360.0, by: 5.0) {
            let x = origin.x + CGFloat(angle/360.0) * width * graphWidth
            let y = origin.y - CGFloat(sin((angle-90)/180.0 * Double.pi)) * height * amplitude
            path.addLine(to: CGPoint(x: x, y: y))
        }

        UIColor.black.setStroke()
        path.stroke()
    }
}
