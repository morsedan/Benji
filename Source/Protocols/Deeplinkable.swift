//
//  Deeplinkable.swift
//  Benji
//
//  Created by Benji Dodgson on 6/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

protocol DeepLinkable {
    var customMetadata: NSMutableDictionary { get set }
    var deepLinkTarget: DeepLinkTarget? { get set }
    var viewController: ViewController? { get }
}
