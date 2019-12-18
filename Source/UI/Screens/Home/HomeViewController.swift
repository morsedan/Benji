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

enum HomeOptionType {
    case profile
    case add
}

enum HomeContentType {
    case feed
    case channels
    case profile
}

protocol HomeViewControllerDelegate: class {
    func homeView(_ controller: HomeViewController, didSelect option: HomeOptionType)
}

typealias HomeDelegate = HomeViewControllerDelegate & ChannelsViewControllerDelegate & FeedViewControllerDelegate

class HomeViewController: FullScreenViewController {

    unowned let delegate: HomeDelegate

    private let addButton = HomeAddButton()
    lazy var feedVC = FeedViewController(with: self.delegate)
    lazy var channelsVC = ChannelsViewController(with: self.delegate)
    let centerContainer = View()
    let tabView = HomeTabView()

    private var currentType: HomeContentType = .feed {
        didSet {
            guard self.currentType != oldValue else { return }
            self.updateContent()
        }
    }

    init(with delegate: HomeDelegate) {
        self.delegate = delegate
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    required init?(withObject object: DeepLinkable) {
        fatalError("init(withObject:) has not been implemented")
    }

    override func initializeViews() {
        super.initializeViews()

        self.view.set(backgroundColor: .background1)

        self.contentContainer.addSubview(self.centerContainer)

        self.addChild(self.channelsVC)
        self.addChild(viewController: self.feedVC, toView: self.centerContainer)

        self.contentContainer.addSubview(self.addButton)
        self.addButton.onTap { [unowned self] (tap) in
            self.delegate.homeView(self, didSelect: .add)
        }

        self.contentContainer.addSubview(self.tabView)
        self.tabView.delegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.addButton.size = CGSize(width: 60, height: 60)
        self.addButton.right = self.view.width - Theme.contentOffset
        self.addButton.bottom = self.contentContainer.height - 10

        self.centerContainer.size = CGSize(width: self.contentContainer.width,
                                           height: self.contentContainer.height - 40)
        self.centerContainer.top = 40
        self.centerContainer.centerOnX()

        self.feedVC.view.frame = self.centerContainer.bounds

        self.tabView.size = CGSize(width: 200, height: 60)
        self.tabView.left = Theme.contentOffset
        self.tabView.bottom = self.addButton.bottom
        self.tabView.roundCorners()
    }

    func updateContent() {

        switch self.currentType {
        case .profile:
            break 
        case .feed:
            self.channelsVC.animateOut { (completed, error) in
                guard completed else { return }
                self.channelsVC.view.removeFromSuperview()
                self.feedVC.animateIn(completion: { (completed, error) in })
            }
        case .channels:
            self.feedVC.animateOut { (completed, error) in
                guard completed else { return }

                self.view.insertSubview(self.channelsVC.view, belowSubview: self.tabView)
                self.channelsVC.view.size = self.centerContainer.size
                self.channelsVC.view.top = 40
                self.channelsVC.view.centerOnX()
                self.channelsVC.animateIn(completion: { (completed, error) in })
            }
        }
    }
}

extension HomeViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.channelsVC.manager.channelFilter = SearchFilter(text: String(), scope: .all)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.currentType = .feed
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let scopeString = searchBar.scopeButtonTitles?[searchBar.selectedScopeButtonIndex],
            let scope = SearchScope(rawValue: scopeString) else { return }
        
        let lowercaseString = searchText.lowercased()
        //self.headerView.searchBar.text = lowercaseString
        self.channelsVC.manager.channelFilter = SearchFilter(text: lowercaseString, scope: scope)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.text = String()
        searchBar.resignFirstResponder()
    }
}

extension HomeViewController: HomeTabViewDelegate {
    func homeTab(_ view: HomeTabView, didSelect tab: HomeContentType) {
        self.currentType = tab
    }
}

