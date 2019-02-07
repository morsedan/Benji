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
    mutating func configure(with item: DisplayableCellItem?)
    func cellIsReadyForLayout()
}

private var itemHandle: UInt8 = 0
private var didSelectHandle: UInt8 = 0
extension DisplayableCell where Self: UICollectionViewCell {

    var item: DisplayableCellItem? {
        get {
            return self.getAssociatedObject(&itemHandle)
        }
        set {
            self.setAssociatedObject(key: &itemHandle, value: newValue)
        }
    }

    static var reuseID: String {
        return String(describing: self)
    }

    mutating func configure(with item: DisplayableCellItem?) {
        self.item = item
        self.cellIsReadyForLayout()
    }
}

extension DisplayableCell where Self: UITableViewCell {

    var item: DisplayableCellItem? {
        get {
            return self.getAssociatedObject(&itemHandle)
        }
        set {
            self.setAssociatedObject(key: &itemHandle, value: newValue)
        }
    }

    static var reuseID: String {
        return String(describing: self)
    }

    mutating func configure(with item: DisplayableCellItem?) {
        self.item = item
        self.cellIsReadyForLayout()
    }
}
