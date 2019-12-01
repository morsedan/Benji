//
//  RoutineTimeLabel.swift
//  Benji
//
//  Created by Benji Dodgson on 12/1/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class RoutineTimeLabel: Display1Label {

    func set(date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm"
        let string = formatter.string(from: date)
        self.set(text: string,
                 color: .lightPurple,
                 alignment: .center)
    }
}
