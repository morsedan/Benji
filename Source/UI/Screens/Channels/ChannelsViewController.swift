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

    private(set) var searchBar = ChannelsSearchBar()
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

        self.view.addSubview(self.searchBar)
        self.searchBar.delegate = self

        self.manager.onSelectedItem.signal.observeValues { (selectedItem) in
            guard let item = selectedItem else { return }
            self.delegate?.channelsView(self, didSelect: item.item.channelType)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.searchBar.size = CGSize(width: self.view.width, height: 120)
        self.searchBar.top = 0
        self.searchBar.centerOnX()
    }
}

extension ChannelsViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.manager.channelFilter = SearchFilter(text: String(), scope: .all)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let scopeString = searchBar.scopeButtonTitles?[searchBar.selectedScopeButtonIndex],
            let scope = SearchScope(rawValue: scopeString) else { return }

        let lowercaseString = searchText.lowercased()
        //self.headerView.searchBar.text = lowercaseString
        self.manager.channelFilter = SearchFilter(text: lowercaseString, scope: scope)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.text = String()
        searchBar.resignFirstResponder()
    }
}
