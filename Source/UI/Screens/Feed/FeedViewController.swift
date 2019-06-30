//
//  HomeStackViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 6/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class FeedViewController: SwipeableViewController {

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

        for index in 0...10 {
            let avatar = SystemAvatar(photoUrl: nil, photo: Lorem.image())
            let systemMessage = SystemMessage(avatar: avatar,
                                              context: Lorem.context(),
                                              body: Lorem.paragraph(),
                                              id: "systemmessage.\(String(index))")
            items.append(.system(systemMessage))
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
        return nil
    }
}
