//
//  RoutineInputViewController.swift
//  Benji
//
//  Created by Martin Young on 8/13/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import UserNotifications
import TMROLocalization

class RoutineInputViewController: ViewController {

    static let height: CGFloat = 500
    let content = RoutineInputContentView()

    var selectedDate = Date()

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
            }
        }

        User.current()?.getRoutine()
        .observe(with: { (result) in
            switch result {
            case .success(let routine):
                self.updateHump(with: routine.timeComponents)
            case .failure(_):
                self.setDefault()
            }
        })

        self.content.minusButton.didSelect = { [unowned self] in

            if let newDate = self.selectedDate.subtract(component: .minute, amount: 15) {
                let dateComponents = Calendar.current.dateComponents([.year, .month, .day,
                                                                      .hour, .minute, .second],
                                                                     from: newDate)
                self.updateHump(with: dateComponents)
            }
        }

        self.content.plusButton.didSelect = { [unowned self] in
            if let newDate = self.selectedDate.add(component: .minute, amount: 15) {
                let dateComponents = Calendar.current.dateComponents([.year, .month, .day,
                                                                      .hour, .minute, .second],
                                                                     from: newDate)
                self.updateHump(with: dateComponents)
            }
        }

        self.content.setRoutineButton.didSelect = { [unowned self] in
            let routine = Routine()
            routine.create(with: self.selectedDate)
            routine.saveEventually()
            .withResultToast(with: "Routine saved")
                .observe { (result) in
                    switch result {
                    case .success(_):
                        self.animateButton(with: .blue, text: "Routine Updated")
                    case .failure(let error):
                        print(error)
                        self.animateButton(with: .red, text: "Error")
                    }
            }
        }
    }

    private func animateButton(with color: Color, text: Localized) {
        UIView.animate(withDuration: Theme.animationDuration, animations: {
            self.content.setRoutineButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.content.setRoutineButton.alpha = 0
        }) { (completed) in
            self.content.setRoutineButton.set(style: .normal(color: color, text: text))
            UIView.animate(withDuration: Theme.animationDuration) {
                self.content.setRoutineButton.transform = .identity
                self.content.setRoutineButton.alpha = 1
            }
        }
    }
    
    private func setDefault() {
        var dateComponents = Calendar.current.dateComponents([.hour, .minute],
                                                             from: Date.today)
        dateComponents.hour = 19
        dateComponents.minute = 0
        self.updateHump(with: dateComponents)
    }

    private func updateHump(with components: DateComponents) {
        var totalSeconds = CGFloat(components.second ?? 0)
        totalSeconds += CGFloat(components.minute ?? 0) * 60
        totalSeconds += CGFloat(components.hour ?? 0) * 3600
        self.content.timeHump.percentage.value = totalSeconds/86400
    }
}
