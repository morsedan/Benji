//
//  HomeSearchBar.swift
//  Benji
//
//  Created by Benji Dodgson on 9/28/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class HomeSearchBar: UISearchBar {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializeSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initializeSubviews() {

        self.keyboardType = .twitter
        self.barStyle = .black
        self.searchBarStyle = .prominent
        self.placeholder = "Search"
        self.tintColor = Color.lightPurple.color
        self.showsCancelButton = false 

        self.setImage(UIImage(systemName: "xmark.circle.fill"), for: .clear, state: .normal)
    }
}
