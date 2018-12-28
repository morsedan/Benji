//
//  DisplyableCell.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

protocol DisplayableCell {
    static var reuseID: String { get }
    var contentViewColor: Color { get }
    var didSelect: (IndexPath) -> Void { get set }
    var indexPath: IndexPath { get set }
    mutating func configure(with item: DisplayableItem, indexPath: IndexPath)
}

extension DisplayableCell where Self: UICollectionViewCell {

    static var reuseID: String {
        return String(describing: self)
    }

    mutating func configure(with item: DisplayableItem,
                            indexPath: IndexPath) {

        self.contentView.set(backgroundColor: self.contentViewColor)
        self.indexPath = indexPath
    }
}

extension DisplayableCell where Self: UITableViewCell {

    static var reuseID: String {
        return String(describing: self)
    }

    mutating func configure(with item: DisplayableItem,
                            indexPath: IndexPath) {

        self.contentView.set(backgroundColor: self.contentViewColor)
        self.indexPath = indexPath
    }
}
