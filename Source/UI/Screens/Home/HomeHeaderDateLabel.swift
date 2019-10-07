//
//  HomeHeaderDateLabel.swift
//  Benji
//
//  Created by Benji Dodgson on 10/5/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class HomeHeaderDateLabel: XXSmallSemiBoldLabel {

    func set(date: Date) {
        self.set(text: self.getString(for: date))
    }

    private func getString(for date: Date) -> String {
        let stringDate = Date.weekdayMonthDayYear.string(from: date)
        return stringDate
    }
}
