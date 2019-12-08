//
//  HomeStackViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 6/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Koloda

protocol FeedViewControllerDelegate: class {
    func feedView(_ controller: FeedViewController, didSelect item: FeedType)
}

class FeedViewController: ViewController {

    private let collectionView = FeedCollectionView()

    lazy var manager: FeedCollectionViewManager = {
        let manager = FeedCollectionViewManager(with: self.collectionView)
        manager.didSelect = { [unowned self] feedType in
            self.delegate.feedView(self, didSelect: feedType)
        }
        return manager
    }()

    unowned let delegate: FeedViewControllerDelegate
    var items: [FeedType] = []
    private let countDownView = CountDownView()
    private let loadButton = LoadingButton()

    init(with delegate: FeedViewControllerDelegate) {
        self.delegate = delegate
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initializeViews() {
        super.initializeViews()

        self.view.addSubview(self.countDownView)
        self.view.addSubview(self.collectionView)

        self.loadButton.set(style: .normal(color: .blue, text: "Load Feed"))
        self.loadButton.alpha = 0

        self.loadButton.onTap { [unowned self] (tap) in
            self.loadFeedItems()
        }

        self.countDownView.didExpire = { [unowned self] in
            self.showLoadingButton()
        }

        self.collectionView.dataSource = self.manager
        self.collectionView.delegate = self.manager

        self.subscribeToUpdates()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.countDownView.size = CGSize(width: 200, height: 60)
        self.countDownView.centerY = self.view.halfHeight * 0.8
        self.countDownView.centerOnX()

        self.loadButton.size = CGSize(width: 200, height: 50)
        self.loadButton.centerY = self.view.halfHeight * 0.8
        self.loadButton.centerOnX()

        self.collectionView.expandToSuperviewSize()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let date = Date().add(component: .second, amount: 5) {
            self.countDownView.startTimer(with: date)
        }
    }

    private func showLoadingButton() {
        self.view.addSubview(self.loadButton)
        self.view.layoutNow()

        UIView.animate(withDuration: Theme.animationDuration, animations: {
            self.countDownView.alpha = 0
            self.countDownView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { (completed) in
            self.countDownView.transform = .identity
            self.loadButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            if completed {
                UIView.animate(withDuration: Theme.animationDuration) {
                    self.loadButton.alpha = 1
                    self.loadButton.transform = .identity
                }
            }
        }
    }

    private func loadFeedItems() {
        self.loadButton.isLoading = true
        UIView.animate(withDuration: Theme.animationDuration,
                       delay: 1.0,
                       options: [], animations: {
                        self.loadButton.alpha = 0
                        self.loadButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { (completed) in
            self.loadButton.removeFromSuperview()
            self.manager.set(items: self.items)
        }
    }

    func animateIn(completion: @escaping CompletionHandler) {
        let animator = UIViewPropertyAnimator(duration: Theme.animationDuration,
                                              curve: .easeInOut) {
                                                self.view.alpha = 1
                                                self.view.layoutNow()
        }
        animator.addCompletion { (position) in
            if position == .end {
                completion(true, nil)
            }
        }

        animator.startAnimation()
    }

    func animateOut(completion: @escaping CompletionHandler) {
        let animator = UIViewPropertyAnimator(duration: Theme.animationDuration,
                                              curve: .easeInOut) {
                                                self.view.alpha = 0
        }
        animator.addCompletion { (position) in
            if position == .end {
                completion(true, nil)
            }
        }

        animator.startAnimation()
    }
}
