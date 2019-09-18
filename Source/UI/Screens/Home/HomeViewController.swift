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

    private let headerContainer = View()
    lazy var avatarView: ProfileAvatarView = {
        let avatarView = ProfileAvatarView()
        if let current = PFUser.current() {
            avatarView.set(avatar: current)
        }
        return avatarView
    }()
    private let searchBar = UISearchBar()
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

        self.addChild(viewController: self.feedVC, toView: self.contentContainer)
        self.addChild(self.channelsVC)

        self.contentContainer.addSubview(self.headerContainer)

        self.headerContainer.addSubview(self.avatarView)
        self.avatarView.onTap { [unowned self] (tap) in
            let vc = ProfileViewController()
            self.present(vc, animated: true, completion: {
                vc.set(avatar: PFUser.current)
            })
        }

        self.headerContainer.addSubview(self.searchBar)
        self.searchBar.delegate = self

        self.contentContainer.addSubview(self.addButton)

        self.addButton.onTap { [unowned self] (tap) in
            self.presentNewChannel()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.headerContainer.size = CGSize(width: self.contentContainer.width, height: 40)
        self.headerContainer.top = self.view.safeAreaInsets.top
        self.headerContainer.centerOnX()

        self.avatarView.size = CGSize(width: 40, height: 40)
        self.avatarView.left = 20
        self.avatarView.centerOnY()

        self.searchBar.size = CGSize(width: self.headerContainer.width - 120, height: 40)
        self.searchBar.left = self.avatarView.right + 20

        self.addButton.size = CGSize(width: 60, height: 60)
        self.addButton.centerOnX()
        self.addButton.bottom = self.contentContainer.height - 25 - self.view.safeAreaInsets.bottom

        let feedHeight = self.contentContainer.height * 0.8
        self.feedVC.view.size = CGSize(width: self.contentContainer.width * 0.85, height: feedHeight)
        self.feedVC.view.centerOnXAndY()

        self.channelsVC.view.width = self.contentContainer.width
        self.channelsVC.view.top = self.headerContainer.bottom
        self.channelsVC.view.height = self.contentContainer.height
        self.channelsVC.view.centerOnX()
    }

    func presentNewChannel() {
        self.present(self.scrolledModal, animated: true, completion: nil)
    }

    func presentContactPicker() {
        let contactController = ContactsScrolledModalController()
        contactController.presentable.delegate = self
        self.present(contactController, animated: true, completion: nil)
    }

    private func resetContent(currentView: UIView, newView: UIView) {
        currentView.removeFromSuperview()
        self.contentContainer.insertSubview(newView, belowSubview: self.headerContainer)
        self.contentContainer.layoutNow()
        newView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        newView.alpha = 0
    }

    func updateContent() {
        let currentType = self.currentType.value

        switch currentType {
        case .feed:
            self.channelsVC.animateOut { (completed, error) in
                if completed {
                    self.resetContent(currentView: self.channelsVC.view, newView: self.feedVC.view)
                    self.feedVC.animateIn(completion: { (completed, error) in })
                }
            }
        case .list:
            self.feedVC.animateOut { (completed, error) in
                if completed {
                    self.resetContent(currentView: self.feedVC.view, newView: self.channelsVC.view)
                    self.channelsVC.animateIn(completion: { (completed, error) in

                    })
                }
            }
        }
    }
}

extension HomeViewController: ContactsViewControllerDelegate {

    func contactsViewController(_ controller: ContactsViewController, didSelect contact: CNContact) {
        self.dismiss(animated: true) {
            guard let phoneNumber = contact.primaryPhoneNumber, let query = PFUser.query() else { return }

            query.whereKey("phoneNumber", equalTo: phoneNumber)

            query.findObjectsInBackground(block: { (objects, error) in
                if let error = error {
                    print(error)
                }

                guard let user = objects?.first, let identifier = user.objectId else { return }
                self.createChannel(with: identifier)
            })
        }
    }

    func createChannel(with inviteeIdentifier: String) {
        ChannelManager.createChannel(channelName: "TEST CHANNEL",
                                     channelDescription: "",
                                     type: .private)
            .joinIfNeeded()
            .invite(personUserID: inviteeIdentifier)
            .withProgressBanner("Creating channel with TEST CHANNEL")
            .withErrorBanner()
            .ignoreUserInteractionEventsUntilDone()
            .observe { (result) in
                switch result {
                case .success(let channel):
                    let channelVC = ChannelViewController(channelType: .channel(channel))
                    self.present(channelVC, animated: true)
                case .failure(let error):
                    if let tomorrowError = error as? ClientError {
                        print(tomorrowError.localizedDescription)
                    } else {
                        print(error.localizedDescription)
                    }
                }
        }
    }
}

extension HomeViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
        self.currentType.value = .list
        self.channelsVC.channelFilter = String()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        self.currentType.value = .feed
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.channelsVC.channelFilter = searchText
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
