//
//  DisplayableCellItem.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

protocol DisplayableCellItem: DisplayableItem, ListDiffable {
    var backgroundColor: Color { get }
}
