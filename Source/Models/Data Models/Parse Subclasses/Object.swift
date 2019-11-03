//
//  SubclassObject.swift
//  Benji
//
//  Created by Benji Dodgson on 11/2/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse

enum ObjectKey: String {
    case objectId
    case createAt
    case updatedAt
}

class Object: PFObject, PFSubclassing {
    
    static func parseClassName() -> String {
        return String(describing: self)
    }
}
