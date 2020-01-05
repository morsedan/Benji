//
//  HomeStackViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 6/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Koloda
import TMROLocalization

protocol FeedViewControllerDelegate: class {
    func feedView(_ controller: FeedViewController, didSelect item: FeedType)
}

class FeedViewController: ViewController {

    private let collectionView = FeedCollectionView()

    lazy var manager: FeedCollectionViewManager = {
        let manager = FeedCollectionViewManager(with: self.collectionView)
        manager.didComplete = { [unowned self] feedType in
            self.delegate?.feedView(self, didSelect: feedType)
        }
        return manager
    }()

    weak var delegate: FeedViewControllerDelegate?
    var items: [FeedType] = []
    private let countDownView = CountDownView()
    private let messageLabel = MediumLabel()
    var message: Localized? {
        didSet {
            guard let text = self.message else { return }
            self.messageLabel.set(text: text, alignment: .center)
        }
    }
    private var currentTriggerDate: Date? {
        return UserDefaults.standard.value(forKey: Routine.currentRoutineKey) as? Date
    }

    override func initializeViews() {
        super.initializeViews()

        self.view.addSubview(self.messageLabel)
        self.messageLabel.alpha = 0
        self.view.addSubview(self.countDownView)
        self.view.addSubview(self.collectionView)

        self.countDownView.didExpire = { [unowned self] in
            self.subscribeToUpdates()
        }

        self.collectionView.dataSource = self.manager
        self.collectionView.delegate = self.manager
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.loadFeed()
    }

    private func loadFeed() {

        User.current()?.getRoutine()
            .observe(with: { (result) in
                switch result {
                case .success(let routine):
                    self.items = []
                    self.determineMessage(with: routine)
                case .failure(_):
                    let items: [FeedType] = [.rountine]
                    self.manager.set(items: items)
                }
            })
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.messageLabel.size = CGSize(width: 300, height: 200)
        self.messageLabel.centerY = self.view.halfHeight * 0.8
        self.messageLabel.centerOnX()

        self.countDownView.size = CGSize(width: 200, height: 60)
        self.countDownView.centerY = self.view.halfHeight * 0.8
        self.countDownView.centerOnX()

        self.collectionView.expandToSuperviewSize()
    }

    private func determineMessage(with routine: Routine) {
        guard let triggerDate = routine.date,
            self.currentTriggerDate != triggerDate,
            let anHourAfter = triggerDate.add(component: .hour, amount: 1),
            let anHourUntil = triggerDate.subtract(component: .hour, amount: 1) else { return }

        self.items = []

        //Set the current trigger date so we dont reload for duplicates
        UserDefaults.standard.set(triggerDate, forKey: Routine.currentRoutineKey)

        let now = Date()

        print("trigger \(triggerDate)")
        print("NOW \(now)")
        print("anHourAfter \(anHourAfter)")
        print("anHourUntil \(anHourUntil)")
        
        //If date is 1 hour or less away, show countDown
        if now.isBetween(anHourUntil, and: triggerDate) {
            self.countDownView.startTimer(with: triggerDate)
            self.showCountDown()

            //If date is less than an hour ahead of current date, show feed
        } else if now.isBetween(triggerDate, and: anHourAfter) {
            self.subscribeToUpdates()

        //If date is 1 hour or more away, show "see you at (date)"
        } else if now.isBetween(Date().beginningOfDay, and: anHourUntil) {
            let dateString = Date.hourMinuteTimeOfDay.string(from: triggerDate)
            self.message = "Take a break! ☕️\nSee you at \(dateString)"
            self.showMessage()
        } else {
            let dateString = Date.hourMinuteTimeOfDay.string(from: triggerDate)
            self.message = "See you tomorrow at \n\(dateString)"
            self.showMessage()
        }

        self.view.layoutNow()
    }

    private func showCountDown() {
        self.messageLabel.alpha = 0
        self.countDownView.alpha = 0
        self.countDownView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)

        UIView.animate(withDuration: Theme.animationDuration, animations: {
            self.countDownView.transform = .identity
            self.countDownView.alpha = 1
        }, completion: nil)
    }

    private func showMessage() {

        self.countDownView.alpha = 0
        self.messageLabel.alpha = 0
        self.view.layoutNow()
        self.messageLabel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)

        UIView.animate(withDuration: Theme.animationDuration, animations: {
            self.messageLabel.transform = .identity
            self.messageLabel.alpha = 1
        }, completion: nil)
    }

    func showFeed() {
        runMain {
            UIView.animate(withDuration: Theme.animationDuration, delay: Theme.animationDuration, options: [], animations: {
                self.countDownView.alpha = 0
                self.countDownView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }, completion: nil)

            self.manager.set(items: self.items)
        }
    }
}
