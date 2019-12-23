//
//  HomeTabView.swift
//  Benji
//
//  Created by Benji Dodgson on 12/17/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class HomeTabView: View {

    private(set) var profileItem = HomeButton()
    private(set) var feedItem = HomeButton()
    private(set) var channelsItem = HomeButton()
    private let selectionFeedback = UIImpactFeedbackGenerator(style: .light)
    
    override func initializeSubviews() {
        super.initializeSubviews()

        self.set(backgroundColor: .clear)

        self.addSubview(self.profileItem)
        self.addSubview(self.feedItem)
        self.addSubview(self.channelsItem)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let itemWidth = self.width * 0.33

        self.profileItem.size = CGSize(width: itemWidth, height: self.height)
        self.profileItem.centerOnY()
        self.profileItem.left = 0

        self.feedItem.size = CGSize(width: itemWidth, height: self.height)
        self.feedItem.centerOnY()
        self.feedItem.left = self.profileItem.right

        self.channelsItem.size = CGSize(width: itemWidth, height: self.height)
        self.channelsItem.centerOnY()
        self.channelsItem.left = self.feedItem.right
    }

    func updateTabItems(for contentType: HomeContent) {
        self.selectionFeedback.impactOccurred()
        
        switch contentType {
        case .feed:
            self.feedItem.imageView.image = UIImage(systemName: "square.stack.fill")
            self.profileItem.imageView.image = UIImage(systemName: "person.crop.circle")
            self.channelsItem.imageView.image = UIImage(systemName: "bubble.left.and.bubble.right")
        case .channels:
            self.feedItem.imageView.image = UIImage(systemName: "square.stack")
            self.profileItem.imageView.image = UIImage(systemName: "person.crop.circle")
            self.channelsItem.imageView.image = UIImage(systemName: "bubble.left.and.bubble.right.fill")
        case .profile:
            self.feedItem.imageView.image = UIImage(systemName: "square.stack")
            self.profileItem.imageView.image = UIImage(systemName: "person.crop.circle.fill")
            self.channelsItem.imageView.image = UIImage(systemName: "bubble.left.and.bubble.right")
        }
    }
}
