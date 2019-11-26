//
//  HomeSearchBar.swift
//  Benji
//
//  Created by Benji Dodgson on 9/28/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

enum SearchScope: String, CaseIterable {
    case all = "All"
    case channels = "#"
    case dms = "@"
}

class HomeSearchBar: UISearchBar {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializeSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initializeSubviews() {

        self.keyboardAppearance = .dark
        self.keyboardType = .twitter
        self.barStyle = .black
        self.searchBarStyle = .prominent
        self.placeholder = "Search"
        self.tintColor = Color.lightPurple.color
        self.showsCancelButton = false
        self.backgroundImage = UIImage()
        self.searchTextField.set(backgroundColor: .background2)

        self.setImage(UIImage(systemName: "xmark.circle.fill"), for: .clear, state: .normal)

        self.scopeButtonTitles = SearchScope.allCases.map({ (scope) -> String in
            return scope.rawValue
        })

        let attributes = StringStyle.init(font: .smallSemiBold, color: .white).attributes
        self.setScopeBarButtonTitleTextAttributes(attributes, for: .normal)

        self.scopeBarBackgroundImage = UIImage()

        let styleAttributes = StringStyle(font: .regularSemiBold, color: .lightPurple).attributes
        self.searchTextField.typingAttributes = styleAttributes
    }
}
