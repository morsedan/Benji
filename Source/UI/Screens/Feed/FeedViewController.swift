//
//  HomeStackViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 6/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class FeedViewController: CollectionViewController<FeedCell, FeedCollectionViewManager> {

    let animateInProperty = UIViewPropertyAnimator(duration: Theme.animationDuration,
                                                   curve: .easeInOut,
                                                   animations: nil)

    let animateOutProperty = UIViewPropertyAnimator(duration: Theme.animationDuration,
                                                   curve: .easeInOut,
                                                   animations: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addItems()
    }

    private func addItems() {
        var items: [FeedType] = []

        for _ in 0...10 {
            items.append(.system(Lorem.systemParagraph()))
        }
        self.manager.set(newItems: items) 
    }

    func animateIn(completion: @escaping CompletionHandler) {
        let animator = UIViewPropertyAnimator(duration: Theme.animationDuration,
                                              curve: .easeInOut) {
                                                self.view.transform = CGAffineTransform.identity
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
                                                self.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                                                self.view.alpha = 0
                                                self.view.setNeedsLayout()
        }
        animator.addCompletion { (position) in
            if position == .end {
                completion(true, nil)
            }
        }

        animator.startAnimation()
    }
}
