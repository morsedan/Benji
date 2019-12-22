//
//  ChannelsViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 2/3/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient

protocol ChannelsViewControllerDelegate: class {
    func channelsView(_ controller: ChannelsViewController, didSelect channelType: ChannelType)
}

class ChannelsViewController: CollectionViewController<ChannelCell, ChannelsCollectionViewManager> {

    weak var delegate: ChannelsViewControllerDelegate?

    init() {
        let collectionView = ChannelsCollectionView()

        super.init(with: collectionView)

        self.subscribeToUpdates()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initializeViews() {
        super.initializeViews()

        self.setupSearchBar()

        self.manager.onSelectedItem.signal.observeValues { (selectedItem) in
            guard let item = selectedItem else { return }
            self.delegate?.channelsView(self, didSelect: item.item.channelType)
        }
    }

    private func setupSearchBar() {
        self.navigationItem.searchController?.searchBar.delegate = self
        self.navigationItem.searchController?.view.tintColor = Color.lightPurple.color
        self.navigationItem.searchController?.searchBar.keyboardAppearance = .dark
        self.navigationItem.searchController?.searchBar.keyboardType = .twitter
        self.navigationItem.searchController?.searchBar.placeholder = "Search"
        self.navigationItem.searchController?.searchBar.setImage(UIImage(systemName: "xmark.circle.fill"), for: .clear, state: .normal)
        let styleAttributes = StringStyle(font: .regularSemiBold, color: .lightPurple).attributes
        self.navigationItem.searchController?.searchBar.searchTextField.typingAttributes = styleAttributes
    }
}

extension ChannelsViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: false)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        self.manager.channelFilter = SearchFilter(text: String())
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let lowercaseString = searchText.lowercased()
        self.manager.channelFilter = SearchFilter(text: lowercaseString)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.text = String()
        searchBar.resignFirstResponder()
    }
}
