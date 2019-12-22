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

    var didPresentSearch: CompletionOptional = nil
    var didDismissSearch: CompletionOptional = nil 

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

        self.manager.onSelectedItem.signal.observeValues { (selectedItem) in
            guard let item = selectedItem else { return }
            self.delegate?.channelsView(self, didSelect: item.item.channelType)
        }
    }
}

extension ChannelsViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text {
            let lowercaseString = text.lowercased()
            self.manager.channelFilter = SearchFilter(text: lowercaseString)
        }
    }
}

extension ChannelsViewController: UISearchControllerDelegate {

    func didPresentSearchController(_ searchController: UISearchController) {
        self.didPresentSearch?()
    }

    func didDismissSearchController(_ searchController: UISearchController) {
        self.manager.channelFilter = SearchFilter(text: String())
        self.manager.loadAllChannels()
        self.didDismissSearch?()
    }
}
