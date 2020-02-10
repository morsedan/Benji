//
//  RoutineInputContentView.swift
//  Benji
//
//  Created by Martin Young on 8/13/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class RoutineInputContentView: View {

    let timeLabel = RoutineTimeLabel()
    let everyDayLabel = SmallBoldLabel()

    let plusButton = Button()
    let minusButton = Button()
    let timeHump = TimeHumpView()
    let setRoutineButton = LoadingButton()

    override func initializeSubviews() {
        super.initializeSubviews()
        
        self.addSubview(self.timeLabel)
        self.addSubview(self.everyDayLabel)
        self.everyDayLabel.set(text: "EVERY DAY",
                               color: .white,
                               alignment: .center,
                               stringCasing: .uppercase)

        self.addSubview(self.plusButton)
        self.plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        self.plusButton.tintColor = Color.lightPurple.color.withAlphaComponent(0.2)

        self.addSubview(self.minusButton)
        self.minusButton.setImage(UIImage(systemName: "minus"), for: .normal)
        self.minusButton.tintColor = Color.lightPurple.color.withAlphaComponent(0.2)
        
        self.addSubview(self.setRoutineButton)
        self.setRoutineButton.set(style: .rounded(color: .purple, text: "SET"))

        self.addSubview(self.timeHump)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.setRoutineButton.setSize(with: self.width)
        self.setRoutineButton.bottom = self.height - 20
        self.setRoutineButton.centerOnX()

        self.timeHump.size = CGSize(width: self.width * 0.9, height: 140)
        self.timeHump.bottom = self.setRoutineButton.top - 100
        self.timeHump.centerOnX()

        self.timeLabel.setSize(withWidth: 220)
        self.timeLabel.centerOnX()
        self.timeLabel.bottom = self.timeHump.top - 140

        self.minusButton.size = CGSize(width: 50, height: 50)
        self.minusButton.centerY = self.timeLabel.centerY
        self.minusButton.right = self.timeLabel.left - 30

        self.plusButton.size = CGSize(width: 50, height: 50)
        self.plusButton.centerY = self.timeLabel.centerY
        self.plusButton.left = self.timeLabel.right + 30

        self.everyDayLabel.setSize(withWidth: 200)
        self.everyDayLabel.centerOnX()
        self.everyDayLabel.top = self.timeLabel.bottom + 10
    }

    func set(date: Date) {
        self.timeLabel.set(date: date)
        self.setNeedsLayout()
    }
}
