//
//  CountDownView.swift
//  Benji
//
//  Created by Benji Dodgson on 12/5/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class CountDownView: View {

    private let hoursComponentLabel = ComponentLabel()
    private let minutesComponentLabel = ComponentLabel()
    private let secondsComponentLabel = ComponentLabel()
    private let midSemicolonLabel = Display2Label()
    private let leftSemicolonLabel = Display2Label()
    private let rightSemicolonLabel = Display2Label()

    private(set) var timer: Timer?

    private var currentSeconds: TimeInterval? {
        didSet {
            self.updateLabels()
        }
    }

    override func initializeSubviews() {
        super.initializeSubviews()

        self.addSubview(self.hoursComponentLabel)
        self.addSubview(self.minutesComponentLabel)
        self.addSubview(self.secondsComponentLabel)
        self.addSubview(self.midSemicolonLabel)
        self.addSubview(self.rightSemicolonLabel)
        self.addSubview(self.leftSemicolonLabel)

        self.midSemicolonLabel.set(text: ":", color: .white, alignment: .center)
        self.rightSemicolonLabel.set(text: ":", color: .white, alignment: .center)
        self.leftSemicolonLabel.set(text: ":", color: .white, alignment: .center)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let componentWidth = self.width * 0.33
        let componentSize = CGSize(width: componentWidth, height: 30)

        self.hoursComponentLabel.size = componentSize
        self.hoursComponentLabel.centerOnY()
        self.hoursComponentLabel.left = 0

        self.midSemicolonLabel.sizeToFit()
        self.midSemicolonLabel.left = self.hoursComponentLabel.right - self.midSemicolonLabel.halfWidth
        self.midSemicolonLabel.centerOnY()

        self.minutesComponentLabel.size = componentSize
        self.minutesComponentLabel.centerOnY()
        self.minutesComponentLabel.left = self.hoursComponentLabel.right

        self.rightSemicolonLabel.sizeToFit()
        self.rightSemicolonLabel.left = self.minutesComponentLabel.right - self.rightSemicolonLabel.halfWidth
        self.rightSemicolonLabel.centerOnY()

        self.secondsComponentLabel.size = componentSize
        self.secondsComponentLabel.centerOnY()
        self.secondsComponentLabel.left = self.minutesComponentLabel.right
    }

    func startTimer(with date: Date) {
        self.currentSeconds = date.timeIntervalSinceNow
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 1.0,
                                          target: self,
                                          selector: #selector(fireTimer),
                                          userInfo: nil,
                                          repeats: true)
        self.timer?.fire()
    }

    @objc private func fireTimer() {
        if var seconds = self.currentSeconds {
            seconds -= 1
            self.currentSeconds = seconds
        }
    }

    private func updateLabels() {
        guard let current = self.currentSeconds else { return }

        let date = Date(timeIntervalSinceReferenceDate: current)

        self.hoursComponentLabel.set(value: date.hour)
        self.minutesComponentLabel.set(value: date.minute)
        self.secondsComponentLabel.set(value: date.second)
    }
}

private class ComponentLabel: Display2Label {

    func set(value: Int) {
        self.set(text: String(value), color: .white, alignment: .center)
    }
}
