//
//  FeedCollectionViewManager.swift
//  Benji
//
//  Created by Benji Dodgson on 7/28/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Koloda

class FeedCollectionViewManager: NSObject {

    private let kolodaView: KolodaView

    private var items: [FeedType] = []

    init(with kolodaView: KolodaView) {
        self.kolodaView = kolodaView
        super.init()
        self.initialize()
    }

    private func initialize() {

    }

    func set(items: [FeedType]) {
        self.items = items
        self.kolodaView.reloadData()
    }
}

extension FeedCollectionViewManager: KolodaViewDataSource {

    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return self.items.count
    }

    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }

    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        guard let item = self.items[safe: index] else { return UIView() }
        let feedView = FeedView()
        feedView.configure(with: item)
        return feedView
    }
}

extension FeedCollectionViewManager: KolodaViewDelegate {


}
