//
//  HomeSegmentControl.swift
//  Benji
//
//  Created by Benji Dodgson on 6/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class HomeSegmentControl: UISegmentedControl {

    init() {
        super.init(frame: .zero)
        self.initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialize() {
        self.insertSegment(withTitle: "FEED", at: 0, animated: false)
        self.insertSegment(withTitle: "LIST", at: 1, animated: false)
    }
}
