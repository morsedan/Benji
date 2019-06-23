//
//  DeeplinkObject.swift
//  Benji
//
//  Created by Benji Dodgson on 6/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

struct DeepLinkObject: DeepLinkable {

    var customMetadata = NSMutableDictionary()
    var deepLinkTarget: DeepLinkTarget?
    var viewController: ViewController? {
        return self.deepLinkTarget?.getViewController(with: self)
    }

    init(target: DeepLinkTarget?) {
        self.deepLinkTarget = target
    }
}
