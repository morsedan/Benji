//
//  SystemMessage.swift
//  Benji
//
//  Created by Benji Dodgson on 6/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

struct SystemMessage: Diffable {

    var body: String
    var id: String

    func diffIdentifier() -> NSObjectProtocol {
        return self.id as NSObjectProtocol
    }
}
