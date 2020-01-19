//
//  LaserView.swift
//  Benji
//
//  Created by Benji Dodgson on 1/18/20.
//  Copyright © 2020 Benjamin Dodgson. All rights reserved.
//

import Foundation

struct Laser {
    var origin: CGPoint
    var focus: CGPoint
}

class LaserView: View {

    private var lasers: [Laser] = []

    func add(laser: Laser) {
        self.lasers.append(laser)
    }

    func clear() {
        self.lasers.removeAll()
        runMain {
            self.setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.saveGState()

        for laser in lasers {
            // 4
            context.addLines(between: [laser.origin, laser.focus])

            context.setStrokeColor(Color.lightPurple.color.withAlphaComponent(0.5).cgColor)
            context.setLineWidth(4.5)
            context.strokePath()

            context.addLines(between: [laser.origin, laser.focus])

            context.setStrokeColor(Color.white.color.withAlphaComponent(0.8).cgColor)
            context.setLineWidth(3.0)
            context.strokePath()
        }

        context.restoreGState()
    }
}
