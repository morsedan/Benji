//
//  RoutineInputContentView.swift
//  Benji
//
//  Created by Martin Young on 8/13/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class RoutineInputContentView: View {

    let timePicker = UIDatePicker()
    let setRoutineButton = Button()
    let timeHump = TimeHumpView()

    override func initializeSubviews() {
        super.initializeSubviews()
        
        self.addSubview(self.timePicker)
        // Don't allow the user to directly interact with the date picker
        self.timePicker.isUserInteractionEnabled = false
        self.timePicker.datePickerMode = UIDatePicker.Mode.time
        self.timePicker.minuteInterval = 30
        self.timePicker.setValue(Color.white.color, forKey: "textColor")

        self.addSubview(self.setRoutineButton)
        self.setRoutineButton.set(style: .rounded(color: Color.blue, text: "Set Routine"),
                                  shouldRound: true,
                                  casingType: StringCasing.uppercase)


        self.addSubview(self.timeHump)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.timePicker.frame = self.bounds
        self.timePicker.height = 150

        self.setRoutineButton.frame = CGRect(x: 0,
                                             y: self.timePicker.bottom,
                                             width: self.width,
                                             height: 40)

        self.timeHump.frame = CGRect(x: 0,
                                     y: self.setRoutineButton.bottom,
                                     width: self.width,
                                     height: 200)
    }
}
