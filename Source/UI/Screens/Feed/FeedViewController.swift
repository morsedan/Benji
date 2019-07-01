//
//  HomeStackViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 6/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class FeedViewController: SwipeableViewController {

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
