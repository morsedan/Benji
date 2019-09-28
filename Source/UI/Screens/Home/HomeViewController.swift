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

    private let headerView = HomeHeaderView()

    private let centerContainer = View()
    private let addButton = HomeAddButton()

    lazy var feedVC = FeedViewController()
    lazy var channelsVC = ChannelsViewController(with: self.delegate)

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

        self.contentContainer.addSubview(self.headerView)
        self.contentContainer.addSubview(self.centerContainer)

        self.addChild(viewController: self.feedVC, toView: self.centerContainer)
        self.addChild(self.channelsVC)

        self.headerView.avatarView.onTap { [unowned self] (tap) in
            let vc = ProfileViewController()
            self.present(vc, animated: true, completion: {
                vc.set(avatar: PFUser.current)
            })
        }

        self.headerView.searchBar.delegate = self

        self.contentContainer.addSubview(self.addButton)

        self.addButton.onTap { [unowned self] (tap) in
            self.presentNewChannel()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.headerView.size = CGSize(width: self.contentContainer.width, height: 40)
        self.headerView.top = 0
        self.headerView.centerOnX()

        let centerHeight = self.contentContainer.height - self.headerView.height
        self.centerContainer.size = CGSize(width: self.contentContainer.width,
                                           height: centerHeight)
        self.centerContainer.top = self.headerView.bottom
        self.centerContainer.centerOnX()

        self.addButton.size = CGSize(width: 60, height: 60)
        self.addButton.centerOnX()
        self.addButton.bottom = self.contentContainer.height - 10

        self.feedVC.view.frame = self.centerContainer.bounds
        self.channelsVC.view.frame = self.centerContainer.bounds
    }

    func presentNewChannel() {
        self.present(self.scrolledModal, animated: true, completion: nil)
    }

    private func resetContent(currentView: UIView, newView: UIView) {
        currentView.removeFromSuperview()
        self.centerContainer.addSubview(newView)
        newView.alpha = 0
    }

    func updateContent() {
        let currentType = self.currentType.value

        switch currentType {
        case .feed:
            self.channelsVC.animateOut { (completed, error) in
                guard completed else { return }
                self.resetContent(currentView: self.channelsVC.view, newView: self.feedVC.view)
                self.feedVC.animateIn(completion: { (completed, error) in })
            }
        case .list:
            self.feedVC.animateOut { (completed, error) in
                guard completed else { return }
                self.resetContent(currentView: self.feedVC.view, newView: self.channelsVC.view)
                self.channelsVC.animateIn(completion: { (completed, error) in })
            }
        }
    }
}

extension HomeViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.headerView.searchBar.showsCancelButton = true
        self.currentType.value = .list
        self.channelsVC.channelFilter = String()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.headerView.searchBar.showsCancelButton = false
        self.currentType.value = .feed
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.channelsVC.channelFilter = searchText
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
