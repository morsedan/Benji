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

    unowned let delegate: ChannelsViewControllerDelegate

    init(with delegate: ChannelsViewControllerDelegate) {
        self.delegate = delegate
        let collectionView = ChannelsCollectionView()

        super.init(with: collectionView)

        self.subscribeToUpdates()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didSelect(item: ChannelType, at indexPath: IndexPath) {
        super.didSelect(item: item, at: indexPath)
        self.delegate.channelsView(self, didSelect: item)
    }
}

extension ChannelsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar

        guard let text = searchBar.text,
            let scopeString = searchBar.scopeButtonTitles?[searchBar.selectedScopeButtonIndex],
            let scope = SearchScope(rawValue: scopeString) else { return }

        self.manager.channelFilter = SearchFilter(text: text.lowercased(), scope: scope)
    }
}

extension ChannelsViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //self.searchVC.searchBar.showsCancelButton = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //self.searchVC.searchBar.showsCancelButton = false
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //let lowercaseString = searchText.lowercased()
        //self.searchVC.searchBar.text = lowercaseString
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
