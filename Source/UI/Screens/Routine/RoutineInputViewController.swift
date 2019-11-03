//
//  RoutineInputViewController.swift
//  Benji
//
//  Created by Martin Young on 8/13/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import UserNotifications

class RoutineInputViewController: ViewController {
    static let height: CGFloat = 500
    let content = RoutineInputContentView()

    var selectedDate: Date {
        return Date()
    }

    override func loadView() {
        self.view = self.content
    }

    override func initializeViews() {
        super.initializeViews()

        self.content.timeHump.percentage.signal.observeValues { [unowned self] (percentage) in
            let calendar = Calendar.current
            var components = DateComponents()
            components.second = Int(percentage * 86400)

           // self.content.timePicker.setDate(calendar.date(from: components)!, animated: false)
        }

        RoutineManager.shared.getRoutineNotifications().observe { (result) in
            runMain {
                switch result {
                case .success(let notificationRequests):
                    guard let trigger = notificationRequests.first?.trigger
                        as? UNCalendarNotificationTrigger else {
                        return
                    }
                    let components = trigger.dateComponents
                    var totalSeconds = CGFloat(components.second ?? 0)
                    totalSeconds += CGFloat(components.minute ?? 0) * 60
                    totalSeconds += CGFloat(components.hour ?? 0) * 3600

                    self.content.timeHump.percentage.value = totalSeconds/86400
                case .failure(_):
                    break
                }
            }
        }

        self.content.setRoutineButton.onTap { [unowned self] (tap) in
            let routine = Routine(messageCheckTime: self.selectedDate)
            RoutineManager.shared.scheduleNotification(for: routine)
        }

//        self.content.minusButton.onTap { [unowned self] (tap) in
//
//        }
//
//        self.content.plusButton.onTap { [unowned self] (tap) in
//            
//        }
    }
}
