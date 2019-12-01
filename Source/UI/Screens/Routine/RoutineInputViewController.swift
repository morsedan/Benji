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

    var selectedDate = Date()

    private let selectionFeedback = UIImpactFeedbackGenerator(style: .light)

    override func loadView() {
        self.view = self.content
    }

    override func initializeViews() {
        super.initializeViews()

        self.content.timeHump.percentage.signal.observeValues { [unowned self] (percentage) in
            let calendar = Calendar.current
            var components = DateComponents()
            components.second = Int(percentage * 86400)

            if let date = calendar.date(from: components) {
                self.selectedDate = date
                self.content.set(date: date)
                self.selectionFeedback.impactOccurred()
            }
        }

        RoutineManager.shared.getRoutineNotifications().observe { (result) in
            runMain {
                switch result {
                case .success(let notificationRequests):
                    guard let trigger = notificationRequests.first?.trigger
                        as? UNCalendarNotificationTrigger else {
                            self.setDefault()
                            return
                    }
                    self.updateHump(with: trigger.dateComponents)
                case .failure(_):
                    break
                }
            }
        }

        self.content.minusButton.onTap { [unowned self] (tap) in

            if let newDate = self.selectedDate.subtract(component: .minute, amount: 15) {
                let dateComponents = Calendar.current.dateComponents([.year, .month, .day,
                                                                      .hour, .minute, .second],
                                                                     from: newDate)
                self.updateHump(with: dateComponents)
            }
        }

        self.content.plusButton.onTap { [unowned self] (tap) in
            if let newDate = self.selectedDate.add(component: .minute, amount: 15) {
                let dateComponents = Calendar.current.dateComponents([.year, .month, .day,
                                                                      .hour, .minute, .second],
                                                                     from: newDate)
                self.updateHump(with: dateComponents)
            }
        }

        self.content.setRoutineButton.onTap { [unowned self] (tap) in
            let routine = Routine(messageCheckTime: self.selectedDate)
            RoutineManager.shared.scheduleNotification(for: routine)
        }
    }
    
    private func setDefault() {
        var dateComponents = Calendar.current.dateComponents([.hour, .minute],
                                                             from: Date.today)
        dateComponents.hour = 7
        dateComponents.minute = 0
        self.updateHump(with: dateComponents)
    }

    private func updateHump(with components: DateComponents) {

        var totalSeconds = CGFloat(components.second ?? 0)
        totalSeconds += CGFloat(components.minute ?? 0) * 60
        totalSeconds += CGFloat(components.hour ?? 0) * 3600

        self.content.timeHump.percentage.value = totalSeconds/86400
        self.selectionFeedback.impactOccurred()
    }
}
