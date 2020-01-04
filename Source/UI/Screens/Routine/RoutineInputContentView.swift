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
    let timeOfDayLabel = RoutineTimeOfDayLabel()
    let everyDayLabel = SmallBoldLabel()

    let plusButton = Button()
    let minusButton = Button()
    let timeHump = TimeHumpView()
    let setRoutineButton = LoadingButton()

    override func initializeSubviews() {
        super.initializeSubviews()
        
        self.addSubview(self.timeLabel)
        self.addSubview(self.timeOfDayLabel)
        self.addSubview(self.everyDayLabel)
        self.everyDayLabel.set(text: "EVERY DAY",
                               color: .white,
                               alignment: .center,
                               stringCasing: .uppercase)

        self.addSubview(self.plusButton)
        self.plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        self.plusButton.tintColor = Color.lightPurple.color.withAlphaComponent(0.6)

        self.addSubview(self.minusButton)
        self.minusButton.setImage(UIImage(systemName: "minus"), for: .normal)
        self.minusButton.tintColor = Color.lightPurple.color.withAlphaComponent(0.6)
        
        self.addSubview(self.setRoutineButton)
        self.setRoutineButton.set(style: .rounded(color: .purple, text: "SET"),
                                  shouldRound: true,
                                  casingType: StringCasing.uppercase)

        self.addSubview(self.timeHump)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.setRoutineButton.size = CGSize(width: 200, height: 40)
        self.setRoutineButton.bottom = self.height - 20
        self.setRoutineButton.centerOnX()
        self.setRoutineButton.makeRound()

        self.timeHump.size = CGSize(width: self.width * 0.9, height: 140)
        self.timeHump.bottom = self.setRoutineButton.top - 100
        self.timeHump.centerOnX()

        self.timeLabel.size = CGSize(width: 120, height: 40)
        self.timeLabel.centerOnX()
        self.timeLabel.bottom = self.timeHump.top - 140

        self.timeOfDayLabel.size = CGSize(width: 30, height: 20)
        self.timeOfDayLabel.left = self.timeLabel.right + 4
        self.timeOfDayLabel.centerY = self.timeLabel.centerY

        self.minusButton.size = CGSize(width: 50, height: 50)
        self.minusButton.centerY = self.timeLabel.centerY
        self.minusButton.right = self.timeLabel.left - 50

        self.plusButton.size = CGSize(width: 50, height: 50)
        self.plusButton.centerY = self.timeLabel.centerY
        self.plusButton.left = self.timeLabel.right + 50

        self.everyDayLabel.setSize(withWidth: 200)
        self.everyDayLabel.centerOnX()
        self.everyDayLabel.top = self.timeLabel.bottom + 10
    }

    func set(date: Date) {
        self.timeLabel.set(date: date)
        self.timeOfDayLabel.set(date: date)
    }
}
