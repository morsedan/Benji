//
//  DisplyableCell.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation
import GestureRecognizerClosures

protocol DisplayableCell {
    static var reuseID: String { get }
    var item: DisplayableCellItem? { get set }
    var didSelect: ((IndexPath) -> Void)? { get set }
    mutating func configure(with item: DisplayableCellItem, indexPath: IndexPath)
    func cellIsReadyForLayout()
}

extension DisplayableCell where Self: UICollectionViewCell {

    static var reuseID: String {
        return String(describing: self)
    }

    mutating func configure(with item: DisplayableCellItem,
                            indexPath: IndexPath) {

        self.item = item
        self.contentView.set(backgroundColor: item.backgroundColor)
        self.contentView.onTap { [unowned self] (tap) in
            self.didSelect?(indexPath)
        }
        self.cellIsReadyForLayout()
    }
}

extension DisplayableCell where Self: UITableViewCell {

    static var reuseID: String {
        return String(describing: self)
    }

    mutating func configure(with item: DisplayableCellItem,
                            indexPath: IndexPath) {

        self.item = item
        self.contentView.set(backgroundColor: item.backgroundColor)
        self.contentView.onTap { [unowned self] (tap) in
            self.didSelect?(indexPath)
        }
        self.cellIsReadyForLayout()
    }
}
