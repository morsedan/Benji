//
//  ProfileViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 7/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse
import TwilioChatClient
import TMROLocalization

struct ProfileItem: ProfileDisplayable {
    var avatar: Avatar? = nil
    var title: String
    var text: String
    var buttonText: Localized?
}

protocol ProfileViewControllerDelegate: class {
    func profileViewControllerDidSelectRoutine(_ controller: ProfileViewController)
    func profileViewControllerDidSelectPhoto(_ controller: ProfileViewController)
}

class ProfileViewController: ViewController {

    private let user: User
    lazy var collectionView = ProfileCollectionView()
    lazy var manager = ProfileCollectionViewManager(with: self.collectionView)
    weak var delegate: ProfileViewControllerDelegate?

    init(with user: User) {
        self.user = user
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = self.collectionView
    }

    override func initializeViews() {
        super.initializeViews()

        self.view.set(backgroundColor: .background1)

        self.collectionView.delegate = self.manager
        self.collectionView.dataSource = self.manager

        self.manager.didTapAvatarAt = { [unowned self] indexPath in
            self.delegate?.profileViewControllerDidSelectPhoto(self)
        }

        self.manager.didTapButtonAt = { [unowned self] indexPath in
            self.delegate?.profileViewControllerDidSelectRoutine(self)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.createItems()
    }

    private func createItems() {
        var items: [ProfileDisplayable] = []

        let avatarItem = ProfileItem(avatar: self.user,
                                     title: String(),
                                     text: String())
        items.append(avatarItem)

        let nameItem = ProfileItem(avatar: nil,
                                   title: "Name",
                                   text: String(optional: self.user.fullName))
        items.append(nameItem)

        let handleItem = ProfileItem(avatar: nil,
                                     title: "Handle",
                                     text: String(optional: self.user.handle))
        items.append(handleItem)

        let localTime = ProfileItem(avatar: nil,
                                    title: "Local Time",
                                    text: Date.nowInLocalFormat)
        items.append(localTime)

        self.user.routine?.fetchIfNeededInBackground(block: { (object, error) in
            if let routine = object as? Routine, let date = routine.date {
                let formatter = DateFormatter()
                formatter.dateFormat = "h:mm a"
                let string = formatter.string(from: date)
                let routineItem = ProfileItem(avatar: nil,
                                              title: "Routine",
                                              text: string.uppercased(),
                                              buttonText: "Update")
                items.append(routineItem)
            } else {
                let routineItem = ProfileItem(avatar: nil,
                                              title: "Routine",
                                              text: "NO ROUTINE SET",
                                              buttonText: "Set")
                items.append(routineItem)
            }
            self.manager.items = items
            self.collectionView.reloadData()
        })
    }
}
