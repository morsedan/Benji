//
//  ProfileCollectionViewManager.swift
//  Benji
//
//  Created by Benji Dodgson on 10/15/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

protocol ProfileDisplayable {
    var avatar: Avatar? { get set }
    var title: String { get set }
    var text: String { get set }
    var hasDetail: Bool { get set }
}

extension ProfileDisplayable {
    var avatar: Avatar? {
        return nil
    }

    var hasDetail: Bool {
        return false
    }
}

class ProfileCollectionViewManager: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let collectionView: CollectionView

    var items: [ProfileDisplayable] = []

    var didSelectItemAt: (IndexPath) -> Void = {_ in }

    init(with collectionView: CollectionView) {
        self.collectionView = collectionView
        super.init()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didSelectItemAt(indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cv = collectionView as? ProfileCollectionView else { fatalError() }

        if indexPath.row == 0 {
            return self.avatarCell(for: cv, at: indexPath)
        }

        return self.detailCell(for: cv, at: indexPath)
    }

    private func avatarCell(for collectionView: ProfileCollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(ProfileAvatarCell.self, for: indexPath)
        if let item = self.items[safe: indexPath.row] {
            cell.configure(with: item)
        }
        return cell
    }

    private func detailCell(for collectionView: ProfileCollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(ProfileDetailCell.self, for: indexPath)
        if let item = self.items[safe: indexPath.row] {
            cell.configure(with: item)
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
