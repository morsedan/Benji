//
//  CenterViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Contacts
import Parse
import ReactiveSwift

enum HomeContentType: Int {
    case feed
    case list
}

class HomeViewController: FullScreenViewController {

    typealias HomeViewControllerDelegate = ChannelsViewControllerDelegate & ChannelPurposeViewControllerDelegate
    unowned let delegate: HomeViewControllerDelegate

    //move
    lazy var newChannelFlowViewController: NewChannelFlowViewController = {
        let controller = NewChannelFlowViewController(delegate: self.delegate)
        return controller
    }()
    lazy var scrolledModal = ScrolledModalViewController(presentable: self.newChannelFlowViewController)

    private let centerContainer = View()
    private let addButton = HomeAddButton()

    lazy var feedVC = FeedViewController()
    lazy var channelsVC = ChannelsViewController(with: self.delegate)
    lazy var searchVC = HomeSearchController(searchResultsController: self.channelsVC)

    private let currentType = MutableProperty<HomeContentType>(.feed)

    init(with delegate: HomeViewControllerDelegate) {
        self.delegate = delegate
        super.init()

        self.currentType.producer.skipRepeats().on { [unowned self] (contentType) in
            self.updateContent()
        }.start()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    required init?(withObject object: DeepLinkable) {
        fatalError("init(withObject:) has not been implemented")
    }

    override func initializeViews() {
        super.initializeViews()

        self.contentContainer.addSubview(self.centerContainer)

        self.addChild(viewController: self.feedVC, toView: self.centerContainer)
        self.searchVC.addChild(viewController: self.channelsVC)

//        self.headerView.avatarView.onTap { [unowned self] (tap) in
//            let vc = ProfileViewController()
//            self.present(vc, animated: true, completion: {
//                vc.set(avatar: PFUser.current)
//            })
//        }

        self.title = "Feed"
        self.navigationItem.searchController = self.searchVC
        self.searchVC.searchBar.delegate = self
        self.searchVC.searchResultsUpdater = self
        self.definesPresentationContext = true

        self.contentContainer.addSubview(self.addButton)

        self.addButton.onTap { [unowned self] (tap) in
            self.presentNewChannel()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.centerContainer.size = CGSize(width: self.contentContainer.width,
                                           height: self.contentContainer.height)
        self.centerContainer.top = 0
        self.centerContainer.centerOnX()

        self.addButton.size = CGSize(width: 60, height: 60)
        self.addButton.centerOnX()
        self.addButton.bottom = self.contentContainer.height - 10

        self.feedVC.view.frame = self.centerContainer.bounds
        self.channelsVC.view.frame = self.searchVC.view.bounds
    }

    func presentNewChannel() {
        self.present(self.scrolledModal, animated: true, completion: nil)
    }

//    private func resetContent(currentView: UIView, newView: UIView) {
//        currentView.removeFromSuperview()
//        self.centerContainer.addSubview(newView)
//        newView.alpha = 0
//    }

    func updateContent() {
        let currentType = self.currentType.value

        switch currentType {
        case .feed:
            self.channelsVC.animateOut { (completed, error) in
                guard completed else { return }
               // self.resetContent(currentView: self.channelsVC.view, newView: self.feedVC.view)
                self.feedVC.animateIn(completion: { (completed, error) in })
            }
        case .list:
            self.feedVC.animateOut { (completed, error) in
                guard completed else { return }
               // self.resetContent(currentView: self.feedVC.view, newView: self.channelsVC.view)
                self.channelsVC.animateIn(completion: { (completed, error) in })
            }
        }
    }
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar

        guard let text = searchBar.text,
            let scopeString = searchBar.scopeButtonTitles?[searchBar.selectedScopeButtonIndex],
            let scope = SearchScope(rawValue: scopeString) else { return }

        self.channelsVC.manager.channelFilter = SearchFilter(text: text.lowercased(), scope: scope)
    }
}

extension HomeViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchVC.searchBar.showsCancelButton = true
        self.currentType.value = .list
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchVC.searchBar.showsCancelButton = false
        self.currentType.value = .feed
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let lowercaseString = searchText.lowercased()
        self.searchVC.searchBar.text = lowercaseString
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
