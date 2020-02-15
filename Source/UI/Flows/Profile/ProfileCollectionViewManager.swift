//
//  ProfileCollectionViewManager.swift
//  Benji
//
//  Created by Benji Dodgson on 10/15/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation


class ProfileCollectionViewManager: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let collectionView: CollectionView

    var items: [ProfileItem] = []

    var didTapButtonAt: (ProfileItem) -> Void = { _ in }

    private let user: User

    init(with collectionView: CollectionView, user: User) {
        self.collectionView = collectionView
        self.user = user
        super.init()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cv = collectionView as? ProfileCollectionView, let item = self.items[safe: indexPath.row] else { fatalError() }

        switch item {
        case .picture:
            return self.avatarCell(for: cv, with: self.user, at: indexPath)
        default:
            return self.detailCell(for: cv, with: item, at: indexPath)
        }
    }

    private func avatarCell(for collectionView: ProfileCollectionView,
                            with avatar: Avatar,
                            at indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(ProfileAvatarCell.self, for: indexPath)

        cell.configure(with: avatar)
        cell.avatarView.didSelect = { [unowned self] in
            self.didTapButtonAt(.picture)
        }

        return cell
    }

    private func detailCell(for collectionView: ProfileCollectionView,
                            with item: ProfileItem,
                            at indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(ProfileDetailCell.self, for: indexPath)
        cell.configure(with: item, for: self.user)
        cell.button.didSelect = { [unowned self] in
            self.didTapButtonAt(item)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }

        let width = collectionView.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right

        if indexPath.row == 0 {
            return CGSize(width: width, height: 140)
        }

        return CGSize(width: width, height: 50)
    }
}
