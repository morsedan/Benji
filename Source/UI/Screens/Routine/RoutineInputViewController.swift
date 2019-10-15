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

    let content = RoutineInputContentView()

    var selectedDate: Date {
        return self.content.timePicker.date
    }

    override func loadView() {
        self.view = self.content

        self.content.setRoutineButton.addTarget(self,
                                                action: #selector(setRoutineTapped(_:)),
                                                for: .touchUpInside)
    }

    @objc func setRoutineTapped(_ sender: UIButton) {
        let routine = Routine(messageCheckTime: self.selectedDate)
        RoutineManager.shared.scheduleNotification(for: routine)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.content.timeHump.percentage.signal.observeValues { [unowned self] (percentage) in
            let calendar = Calendar.current
            var components = DateComponents()
            components.second = Int(percentage * 86400)

            self.content.timePicker.setDate(calendar.date(from: components)!, animated: false)
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
    }
}
