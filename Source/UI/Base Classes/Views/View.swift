//
//  View.swift
//  Benji
//
//  Created by Benji Dodgson on 12/25/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

class View: UIView {

    init() {
        super.init(frame: .zero)
        self.initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }

    func initialize() { }

    func showShadow(withOffset offset: CGFloat) {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: offset)
        self.layer.shadowRadius = 10
        self.layer.masksToBounds = false
    }
}
