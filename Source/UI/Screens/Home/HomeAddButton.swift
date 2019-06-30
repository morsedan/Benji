//
//  HomeAddButton.swift
//  Benji
//
//  Created by Benji Dodgson on 6/29/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class HomeAddButton: View {

    override func initializeViews() {
        super.initializeViews()

        self.set(backgroundColor: .purple)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.makeRound()
    }
}
