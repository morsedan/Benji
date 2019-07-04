//
//  HomeStackViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 6/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class FeedViewController: SwipeableViewController {

    let animateInProperty = UIViewPropertyAnimator(duration: Theme.animationDuration,
                                                   curve: .easeInOut,
                                                   animations: nil)

    let animateOutProperty = UIViewPropertyAnimator(duration: Theme.animationDuration,
                                                   curve: .easeInOut,
                                                   animations: nil)

    lazy var emptyView: EmptyFeedView = {
        let view = EmptyFeedView()
        view.text = LocalizedString(id: "", default: "🎉 You are all done!")
        return view
    }()

    private var items: [FeedType] = [] {
        didSet {
            self.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.addItems()
    }

    private func addItems() {
        var items: [FeedType] = []

        for _ in 0...10 {
            items.append(.system(Lorem.systemParagraph()))
        }
        self.items = items 
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

extension FeedViewController: SwipeableDataSource {

    func numberOfCards() -> Int {
        return self.items.count
    }

    func card(forItemAtIndex index: Int) -> SwipeableView {
        guard let item = self.items[safe: index] else { return SwipeableView() }

        let feedCell = FeedCell()
        feedCell.configure(with: item)

        return feedCell
    }

    func viewForEmptyCards() -> UIView? {
        return nil//self.emptyView
    }
}
