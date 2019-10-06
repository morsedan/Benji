//
//  HomeStackViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 6/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Koloda

class FeedViewController: ViewController {

    private let kolodaView = KolodaView()

    lazy var manager: FeedCollectionViewManager = {
        let manager = FeedCollectionViewManager(with: self.kolodaView)
        return manager
    }()

    override func initializeViews() {
        super.initializeViews()

        self.view.addSubview(self.kolodaView)

        self.kolodaView.dataSource = self.manager
        self.kolodaView.delegate = self.manager

        self.subscribeToUpdates()
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let feedHeight = self.view.height * 0.8
        self.kolodaView.size = CGSize(width: self.view.width * 0.85, height: feedHeight)
        self.kolodaView.top = Theme.contentOffset
        self.kolodaView.centerOnX()
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
                                                self.view.layoutNow()
        }
        animator.addCompletion { (position) in
            if position == .end {
                completion(true, nil)
            }
        }

        animator.startAnimation()
    }
}
