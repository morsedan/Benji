//
//  Avatar.swift
//  Benji
//
//  Created by Benji Dodgson on 6/23/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

/// An object used to group the information to be used by an `AvatarView`.
public struct Avatar {

    // MARK: - Properties

    /// The image to be used for an `AvatarView`.
    public let image: UIImage?

    /// The placeholder initials to be used in the case where no image is provided.
    ///
    /// The default value of this property is "?".
    public var initials: String = "?"

    // MARK: - Initializer

    public init(image: UIImage? = nil, initials: String = "?") {
        self.image = image
        self.initials = initials
    }

}
