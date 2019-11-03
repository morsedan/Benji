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
    var givenName: String? { get }
    var familyName: String? { get }
    var fullName: String? { get }
    var handle: String? { get }
}

extension Avatar {
    
    var fullName: String? {
        guard let first = self.givenName else { return nil }

        if let last = self.familyName {
            return first + " " + last
        }

        return first
    }

    var initials: String {
        let firstInitial = String(optional: self.givenName?.first?.uppercased())
        let lastInitial = String(optional: self.familyName?.first?.uppercased())
        return firstInitial + lastInitial
    }
}
