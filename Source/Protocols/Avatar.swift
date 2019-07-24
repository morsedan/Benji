//
//  Avatar.swift
//  Benji
//
//  Created by Benji Dodgson on 6/23/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

protocol Avatar: ImageDisplayable {
    var initials: String { get }
    var firstName: String { get }
    var lastName: String { get }
    var handle: String { get }
}
