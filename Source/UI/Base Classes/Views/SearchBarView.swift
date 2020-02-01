//
//  SearchBarView.swift
//  Benji
//
//  Created by Benji Dodgson on 2/1/20.
//  Copyright © 2020 Benjamin Dodgson. All rights reserved.
//

import Foundation

class SearchBarView: View {

    private let searchBar = SearchBar()

    override func initializeSubviews() {
        super.initializeSubviews()

        self.addSubview(self.searchBar)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.searchBar.expandToSuperviewSize()
    }
}

private class SearchBar: UISearchBar {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializeSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initializeSubviews() {
        self.tintColor = Color.lightPurple.color
        self.keyboardAppearance = .dark
        self.keyboardType = .twitter
        self.placeholder = "Search"
        self.setImage(UIImage(systemName: "xmark.circle.fill"), for: .clear, state: .normal)
        let styleAttributes = StringStyle(font: .regularBold, color: .lightPurple).attributes
        self.searchTextField.typingAttributes = styleAttributes
    }
}
