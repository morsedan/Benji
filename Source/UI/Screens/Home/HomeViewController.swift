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
    case search
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

    unowned let delegate: HomeViewControllerDelegate

    private let addButton = HomeAddButton()
    lazy var feedVC = FeedViewController()
    let headerView = HomeHeaderView()
    private let currentType = MutableProperty<HomeContentType>(.feed)

    init(with delegate: HomeViewControllerDelegate) {
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

        self.contentContainer.addSubview(self.headerView)

        self.addChild(viewController: self.feedVC, toView: self.contentContainer)

        self.headerView.avatarView.onTap { [unowned self] (tap) in
            self.delegate.homeView(self, didSelect: .profile)
        }

        self.contentContainer.addSubview(self.addButton)
        self.addButton.onTap { [unowned self] (tap) in
            self.delegate.homeView(self, didSelect: .add)
        }

        self.currentType.producer.skipRepeats().on { [unowned self] (contentType) in
            self.updateContent()
        }.start()

        self.headerView.searchBar.delegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.headerView.frame = CGRect(x: 0,
                                       y: 50,
                                       width: self.view.width,
                                       height: HomeHeaderView.height)

        self.addButton.size = CGSize(width: 60, height: 60)
        self.addButton.centerOnX()
        self.addButton.bottom = self.contentContainer.height - 10

        self.feedVC.view.size = CGSize(width: self.contentContainer.width,
                                       height: self.contentContainer.height - self.headerView.bottom)
        self.feedVC.view.top = self.headerView.bottom
        self.feedVC.view.centerOnX()
    }

        func updateContent() {
            let currentType = self.currentType.value
            self.headerView.updateContent(for: currentType)

    //        switch currentType {
    //        case .feed:
    //            self.channelsVC.animateOut { (completed, error) in
    //                guard completed else { return }
    //               // self.resetContent(currentView: self.channelsVC.view, newView: self.feedVC.view)
    //                self.feedVC.animateIn(completion: { (completed, error) in })
    //            }
    //        case .list:
    //            self.feedVC.animateOut { (completed, error) in
    //                guard completed else { return }
    //               // self.resetContent(currentView: self.feedVC.view, newView: self.channelsVC.view)
    //                self.channelsVC.animateIn(completion: { (completed, error) in })
    //            }
    //        }
        }

}

extension HomeViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.currentType.value = .channels
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.currentType.value = .feed
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let scopeString = searchBar.scopeButtonTitles?[searchBar.selectedScopeButtonIndex],
            let scope = SearchScope(rawValue: scopeString) else { return }
        
        //let lowercaseString = searchText.lowercased()
        //self.searchVC.searchBar.text = lowercaseString
        //self.channelsVC.manager.channelFilter = SearchFilter(text: text.lowercased(), scope: scope)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

