//
//  User.swift
//  Benji
//
//  Created by Benji Dodgson on 6/23/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse

class User: PFUser, Avatar {
    var photoUrl: URL?
    var photo: UIImage?
    var initials: String {
        return "BD"
    }

    var firstName: String {
        return String()
    }

    var lastName: String {
        return String()
    }

    var handle: String {
        return "@handle"
    }
}
