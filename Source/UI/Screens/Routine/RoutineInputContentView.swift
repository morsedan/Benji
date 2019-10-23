//
//  RoutineInputContentView.swift
//  Benji
//
//  Created by Martin Young on 8/13/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class RoutineInputContentView: View {

    let timeLabel = Display1Label() // Displays the clock time. e.g. 6:34
    let timePeriodLabel = XSmallLabel() // AM/PM label
    let everyDayLabel = XXSmallSemiBoldLabel() // Displays the frequency of the routine

    let plusButton = Button()
    let minusButton = Button()
    let timeHump = TimeHumpView()
    let setRoutineButton = Button()

    override func initializeSubviews() {
        super.initializeSubviews()
        
        self.addSubview(self.timeLabel)
        self.timeLabel.set(text: "6:00",
                           color: .lightPurple,
                           alignment: .center)
        self.addSubview(self.timePeriodLabel)
        self.timePeriodLabel.set(text: "PM",
                                color: .lightPurple,
                                alignment: .left,
                                stringCasing: .uppercase)

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
        self.setRoutineButton.set(style: .rounded(color: .blue, text: "SET"),
                                  shouldRound: true,
                                  casingType: StringCasing.uppercase)

        self.addSubview(self.timeHump)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.setRoutineButton.size = CGSize(width: self.width * 0.9, height: 40)
        self.setRoutineButton.bottom = self.height
        self.setRoutineButton.centerOnX()
        self.setRoutineButton.makeRound()

        self.timeHump.size = CGSize(width: self.width * 0.9, height: 160)
        self.timeHump.bottom = self.setRoutineButton.top - 100
        self.timeHump.centerOnX()

        self.timeLabel.sizeToFit()
        self.timeLabel.centerOnX()
        self.timeLabel.bottom = self.timeHump.top - 140

        self.timePeriodLabel.setSize(withWidth: 40)
        self.timePeriodLabel.left = self.timeLabel.right + 4
        self.timePeriodLabel.centerY = self.timeLabel.centerY

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
}
