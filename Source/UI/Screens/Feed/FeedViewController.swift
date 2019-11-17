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

    private let collectionView = FeedCollectionView()

    lazy var manager: FeedCollectionViewManager = {
        let manager = FeedCollectionViewManager(with: self.collectionView)
        return manager
    }()

    override func loadView() {
        self.view = self.collectionView
    }

    override func initializeViews() {
        super.initializeViews()

        self.collectionView.dataSource = self.manager
        self.collectionView.delegate = self.manager

        self.subscribeToUpdates()
    }

    func animateIn(completion: @escaping CompletionHandler) {
        let animator = UIViewPropertyAnimator(duration: Theme.animationDuration,
                                              curve: .easeInOut) {
                                                self.view.alpha = 1
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
