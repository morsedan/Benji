//
//  HomeHeaderDateLabel.swift
//  Benji
//
//  Created by Benji Dodgson on 10/5/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class HomeHeaderDateLabel: Label {

    func set(date: Date) {
        let attributed = AttributedString(self.getString(for: date),
                                          fontType: .xxSmallSemiBold,
                                          color: .white)
        self.set(attributed: attributed,
                 alignment: .left,
                 lineCount: 1,
                 stringCasing: .unchanged)
    }

    private func getString(for date: Date) -> String {
        let stringDate = Date.weekdayMonthDayYear.string(from: date)
        return stringDate
    }
}
