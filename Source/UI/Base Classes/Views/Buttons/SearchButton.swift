//
//  SearchButton.swift
//  Benji
//
//  Created by Benji Dodgson on 12/15/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class SearchButton: Button {

    override func initializeSubviews() {

        self.setImage(UIImage(systemName: "magnifyingglass.circle"), for: .normal)
        self.tintColor = Color.background3.color
    }
}
