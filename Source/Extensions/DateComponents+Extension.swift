//
//  DateComponents+Extension.swift
//  Benji
//
//  Created by Martin Young on 10/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

extension DateComponents {

    // Creates hour/min date components based what percentage of a day has passed.
    // 0.0 means midnight. 0.5 is noon
    init(percentageOfDay: Float) {
        let hourPercentageOfDay: Float = 0.041666667
        let hours = Int(percentageOfDay/hourPercentageOfDay)
        // Get the number of minutes by calculating the remaining fraction of an hour
        // and multiplying by 60 minutes
        let minutes = Int(percentageOfDay.truncatingRemainder(dividingBy: 0.041666667)/0.041666667*60)

        self.init()

        self.hour = hours
        self.minute = minutes
    }
}
