//
//  Toast.swift
//  Benji
//
//  Created by Benji Dodgson on 7/23/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

struct Toast: Equatable {
    var id: String
    var analyticsID: String
    var priority: Int = 0
    var title: Localized
    var button: LoadingButton
    var displayable: ImageDisplayable

    static func == (lhs: Toast, rhs: Toast) -> Bool {
        return lhs.id == rhs.id
    }
}
