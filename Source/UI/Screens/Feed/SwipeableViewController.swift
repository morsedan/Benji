//
//  SwipeableViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 6/30/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

enum PageDirection {
    case forward
    case backward
}

protocol SwipeableViewControllerDelegate: class {
    func swipeableView(_ controller: SwipeableViewController, didPresnent index: Int)
}

class SwipeableViewController: ViewController, SwipeableViewDelegate {

    let horizontalInset: CGFloat = 12.0
    let verticalInset: CGFloat = 12.0

    weak var dataSource: SwipeableDataSource? {
        didSet {
            self.reloadData()
        }
    }

    var delegate: SwipeableViewControllerDelegate?

    private(set) var swipeableViews: [SwipeableView] = []
    var currentView: SwipeableView? {
        return self.visibleViews.last
    }
    private var visibleViews: [SwipeableView] {
        return self.view.subviews as? [SwipeableView] ?? []
    }

    fileprivate var remainingCards: Int = 0
    let numberOfVisibleCards: Int = 3
    var isRecursive: Bool = false
    var direction: PageDirection = .backward

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.set(backgroundColor: .clear)
    }

    /// Reloads the data used to layout card views in the
    /// card stack. Removes all existing card views and
    /// calls the dataSource to layout new card views.
    func reloadData() {
        runMain {
            self.removeAllCardViews(direction: self.direction) { [unowned self] in

                guard let dataSource = self.dataSource else {
                    return
                }

                let numberOfCards = dataSource.numberOfCards()
                self.remainingCards = numberOfCards

                if let emptyView = dataSource.viewForEmptyCards() {
                    self.view.addSubview(emptyView)
                    emptyView.autoPinEdgesToSuperviewEdges()
                }

                for index in 0..<min(numberOfCards, self.numberOfVisibleCards) {
                    self.addCardView(cardView: dataSource.card(forItemAtIndex: index), atIndex: index)
                }

                self.view.layoutNow()
            }
        }
    }

    private func addCardView(cardView: SwipeableView, atIndex index: Int) {
        cardView.delegate = self
        self.swipeableViews.append(cardView)
        self.view.insertSubview(cardView, at: 0)
        self.setFrame(forCardView: cardView, atIndex: index)
        self.remainingCards -= 1
        cardView.alpha = 0

        UIView.animate(withDuration: 0.1,
                       delay: 0.1 * TimeInterval(index),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        cardView.alpha = 1
        },
                       completion: nil)
    }

    private func removeAllCardViews(direction: PageDirection, completion: @escaping () -> Void) {
        guard self.visibleViews.count > 0 else {
            completion()
            return
        }

        let multiplier: CGFloat = direction == .backward ? -1.0 : 1.0
        let offset = self.view.width * multiplier

        for (index, cardView) in self.visibleViews.reversed().enumerated() {

            UIView.animate(withDuration: 0.1,
                           delay: 0.0,
                           options: UIView.AnimationOptions.allowUserInteraction,
                           animations: {
                            cardView.centerX = self.view.centerX + offset
            }) { (completed) in
                cardView.removeFromSuperview()

                if index == self.numberOfVisibleCards - 1 {
                    self.swipeableViews = []
                    completion()
                }
            }
        }
    }

    /// Sets the frame of a card view provided for a given index. Applies a specific
    /// horizontal and vertical offset relative to the index in order to create an
    /// overlay stack effect on a series of cards.
    ///
    /// - Parameters:
    ///   - cardView: card view to update frame on
    ///   - index: index used to apply horizontal and vertical insets
    private func setFrame(forCardView cardView: SwipeableView, atIndex index: Int) {
        var cardViewFrame = self.view.bounds
        let horizontalInset = CGFloat(index) * self.horizontalInset
        let verticalInset = CGFloat(index) * self.verticalInset

        cardViewFrame.size.width -= 2 * horizontalInset
        cardViewFrame.origin.x += horizontalInset
        cardViewFrame.origin.y += verticalInset

        cardView.frame = cardViewFrame
        self.didSetFrame(for: cardView, at: index)
    }

    func didSetFrame(for swipeableView: SwipeableView, at index: Int) { }

    func swipeableViewSelected(_ view: SwipeableView) {
        if let index = self.swipeableViews.firstIndex(of: view) {
            self.delegate?.swipeableView(self, didPresnent: index)
        }
    }

    func swipeableViewDidBeginSwipe(_ view: SwipeableView) {
        // React to Swipe Began?
    }

    func swipeableViewDidEndSwipe(_ view: SwipeableView) {
        guard let dataSource = self.dataSource else { return }

        // Remove swiped card
        view.removeFromSuperview()

        if self.isRecursive {
            let remaining = self.remainingCards == 0 ? dataSource.numberOfCards() : self.remainingCards
            self.remainingCards = remaining
        }

        // Only add a new card if there are cards remaining
        if self.remainingCards > 0 {
            // Calculate new card's index
            let newIndex = dataSource.numberOfCards() - self.remainingCards

            // Add new card as Subview
            self.addCardView(cardView: dataSource.card(forItemAtIndex: newIndex), atIndex: self.numberOfVisibleCards - 1)

            // Update all existing card's frames based on new indexes, animate frame change
            // to reveal new card from underneath the stack of existing cards.
            for (cardIndex, cardView) in self.visibleViews.reversed().enumerated() {
                UIView.animate(withDuration: 0.2, animations: {
                    cardView.center = self.view.center
                    self.setFrame(forCardView: cardView, atIndex: cardIndex)
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
}

