//
//  CancelButton.swift
//  Benji
//
//  Created by Benji Dodgson on 12/15/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class CancelButton: Button {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializeSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initializeSubviews() {
        self.setImage(UIImage(systemName: "xmark.square"), for: .normal)
        self.setImage(UIImage(systemName: "xmark.square.fill"), for: .highlighted)
    }
}
