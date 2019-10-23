//
//  RoutineInputViewController.swift
//  Benji
//
//  Created by Martin Young on 8/13/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import UserNotifications

protocol RoutineInputViewControllerDelegate: class {
    func routineInputViewControllerSetRoutine(_ controller: RoutineInputViewController)
}

class RoutineInputViewController: ViewController {

    private let content = RoutineInputContentView()

    private unowned let delegate: RoutineInputViewControllerDelegate

    init(delegate: RoutineInputViewControllerDelegate) {
        self.delegate = delegate
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = self.content
    }

    override func initializeViews() {
        super.initializeViews()

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

        // React to updates to the
        self.content.timeHump.percentage.signal.observeValues { [unowned self] (percentage) in
            var components = DateComponents(percentageOfDay: Float(percentage))
            components.minute = round(components.minute ?? 0, toNearest: 15)

            self.content.timeLabel.set(text: "\(components.hour!):\(components.minute!)",
                                       color: .lightPurple,
                                       alignment: .right)
        }

        self.content.setRoutineButton.onTap { [unowned self] (tap) in
//            let routine = Routine(messageCheckTime: self.selectedDate)
//            RoutineManager.shared.scheduleNotification(for: routine)
        }

        self.content.minusButton.onTap { [unowned self] (tap) in

        }

        self.content.plusButton.onTap { [unowned self] (tap) in
            
        }
    }
}
