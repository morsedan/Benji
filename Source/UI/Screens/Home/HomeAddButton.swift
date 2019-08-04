//
//  HomeAddButton.swift
//  Benji
//
//  Created by Benji Dodgson on 6/29/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class HomeAddButton: View {

    override func initialize() {
        self.set(backgroundColor: .purple)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.makeRound()
        self.layer.shadowColor = Color.purple.color.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowRadius = 5
        self.layer.masksToBounds = false
    }
}
