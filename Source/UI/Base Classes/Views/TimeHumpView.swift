//
//  TimeHump.swift
//  Benji
//
//  Created by Martin Young on 8/27/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class TimeHumpView: View {

    let sliderView = View()
    var amplitude: CGFloat {
        return self.height * 0.5
    }

    private var startPanPercentage: CGFloat = 0

    var percentage: CGFloat = 0 {
        didSet {
            self.setNeedsLayout()
        }
    }

    override func initialize() {
        super.initialize()

        self.sliderView.set(backgroundColor: Color.white)
        self.sliderView.size = CGSize(width: 30, height: 30)
        self.addSubview(self.sliderView)

        self.onPan { [unowned self] (panRecognizer) in
            self.handlePan(panRecognizer)
        }
    }

    // MARK: Layout

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

    override func layoutSubviews() {
        super.layoutSubviews()

        let sliderCenter = self.getPoint(normalizedX: clamp(self.percentage, 0, 1))
        self.sliderView.center = sliderCenter
    }

    func getPoint(normalizedX: CGFloat) -> CGPoint {

        let angle = normalizedX * twoPi

        let x = self.width * normalizedX
        let y = (self.height * 0.5) - (sin(angle - halfPi) * self.amplitude)

        return CGPoint(x: x, y: y)
    }

    // MARK: Touch Input

    private func handlePan(_ panRecognizer: UIPanGestureRecognizer) {

        switch panRecognizer.state {
        case .began:
            self.startPanPercentage = self.percentage
        case .changed:
            let translation = panRecognizer.translation(in: self)
            let normalizedTranslationX = translation.x/self.width
            self.percentage = self.startPanPercentage + normalizedTranslationX
        case .ended:
            let velocity = panRecognizer.velocity(in: self)
            self.animateToFinalPosition(withCurrentVelocity: velocity.x)
        case .possible, .cancelled, .failed:
            break
        @unknown default:
            break
        }
    }

    private func animateToFinalPosition(withCurrentVelocity velocity: CGFloat) {
        self.animateToPercentage(percentage: self.percentage + velocity * 0.01)
    }

    func animateToPercentage(percentage: CGFloat) {

        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: {
                        self.percentage = percentage
        })
    }
}

let halfPi: CGFloat = CGFloat.pi * 0.5
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
