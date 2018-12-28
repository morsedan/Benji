//
//  ImageDisplayable.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

protocol ImageDisplayable {
    var photoUrl: URL? { get }
    var photo: UIImage? { get }
}
