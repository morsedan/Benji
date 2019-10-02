//
//  HomeSearchController.swift
//  Benji
//
//  Created by Benji Dodgson on 10/1/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

enum SearchScope: String, CaseIterable {
    case all = "All"
    case channels = "#"
    case dms = "@"
}

class HomeSearchController: UISearchController {

    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
        self.initializeSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initializeSubviews() {

        self.obscuresBackgroundDuringPresentation = true
        self.searchBar.scopeButtonTitles = SearchScope.allCases.map({ (scope) -> String in
            return scope.rawValue
        })
    }
}
