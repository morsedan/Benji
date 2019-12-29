//
//  OrbCellItem.swift
//  Benji
//
//  Created by Benji Dodgson on 12/28/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

struct OrbCellItem: ManageableCellItem {

    let id: String
    let avatar: AnyHashableDisplayable

    init(id: String, avatar: AnyHashableDisplayable) {
        self.id = id
        self.avatar = avatar
    }
}
