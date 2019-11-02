//
//  SubclassObject.swift
//  Benji
//
//  Created by Benji Dodgson on 11/2/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse

class Object: PFObject, PFSubclassing {
    
    static func parseClassName() -> String {
        return String(describing: self)
    }
}
