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
}

protocol HomeViewControllerDelegate: class {
    func homeView(_ controller: HomeViewController, didSelect option: HomeOptionType)
}

class HomeViewController: FullScreenViewController {

    unowned let delegate: HomeViewControllerDelegate & ChannelsViewControllerDelegate

    private let addButton = HomeAddButton()
    lazy var feedVC = FeedViewController()
    lazy var channelsVC = ChannelsViewController(with: self.delegate)
    let centerContainer = View()
    let headerView = HomeHeaderView()

    private var currentType: HomeContentType = .feed {
        didSet {
            guard self.currentType != oldValue else { return }
           // self.updateContent()
        }
    }

    init(with delegate: HomeViewControllerDelegate & ChannelsViewControllerDelegate) {
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

        self.contentContainer.addSubview(self.headerView)
        self.contentContainer.addSubview(self.centerContainer)

        //self.addChild(viewController: self.channelsVC, toView: self.centerContainer)
        self.addChild(viewController: self.feedVC, toView: self.centerContainer)

        self.headerView.avatarView.onTap { [unowned self] (tap) in
            self.delegate.homeView(self, didSelect: .profile)
        }

        self.contentContainer.addSubview(self.addButton)
        self.addButton.onTap { [unowned self] (tap) in
            self.delegate.homeView(self, didSelect: .add)
        }

        self.headerView.searchBar.delegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.headerView.frame = CGRect(x: 0,
                                       y: 0,
                                       width: self.view.width,
                                       height: HomeHeaderView.height)

        self.addButton.size = CGSize(width: 60, height: 60)
        self.addButton.centerOnX()
        self.addButton.bottom = self.contentContainer.height - 10

        self.centerContainer.size = CGSize(width: self.contentContainer.width,
                                           height: self.contentContainer.height - self.headerView.bottom)
        self.centerContainer.top = self.headerView.bottom
        self.centerContainer.centerOnX()

        self.feedVC.view.frame = self.centerContainer.bounds
        self.channelsVC.view.frame = self.centerContainer.bounds
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        once(caller: self, token: "listenForCenter") {
//            self.feedVC.animateIn(completion: { (completed, error) in
//                self.feedVC.view.layoutNow()
//            })
        }
    }

//    func updateContent() {
//        self.headerView.updateContent(for: self.currentType)
//
//        switch self.currentType {
//        case .feed:
//            self.channelsVC.animateOut { (completed, error) in
//                guard completed else { return }
//                self.centerContainer.sendSubviewToBack(self.channelsVC.view)
//                self.feedVC.animateIn(completion: { (completed, error) in
//                    self.feedVC.view.layoutNow()
//                })
//            }
//        case .channels:
//            self.feedVC.animateOut { (completed, error) in
//                guard completed else { return }
//                self.centerContainer.sendSubviewToBack(self.feedVC.view)
//                self.channelsVC.animateIn(completion: { (completed, error) in })
//            }
//        }
//    }
}

extension HomeViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.channelsVC.manager.channelFilter = SearchFilter(text: String(), scope: .all)
        self.currentType = .channels
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.currentType = .feed
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let scopeString = searchBar.scopeButtonTitles?[searchBar.selectedScopeButtonIndex],
            let scope = SearchScope(rawValue: scopeString) else { return }
        
        let lowercaseString = searchText.lowercased()
        self.headerView.searchBar.text = lowercaseString
        self.channelsVC.manager.channelFilter = SearchFilter(text: lowercaseString, scope: scope)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.text = String()
        searchBar.resignFirstResponder()
    }
}

