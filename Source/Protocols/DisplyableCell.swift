//
//  DisplyableCell.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

protocol DisplayableCellItem: Diffable {
    var backgroundColor: Color { get }
}

protocol DisplayableCell: class {
    associatedtype ItemType: DisplayableCellItem

    static var reuseID: String { get }
    static var hasXib: Bool { get set }
    func configure(with item: ItemType?)
}

extension DisplayableCell where Self: UICollectionViewCell {
    static var reuseID: String {
        return String(describing: self)
    }
}

extension DisplayableCell where Self: UITableViewCell {
    static var reuseID: String {
        return String(describing: self)
    }
}
