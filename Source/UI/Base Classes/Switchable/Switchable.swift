//
//  Switchable.swift
//  Benji
//
//  Created by Benji Dodgson on 1/16/20.
//  Copyright © 2020 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TMROLocalization

protocol SwitchableContent: Equatable {
    var viewController: ViewController { get }
    var shouldShowBackButton: Bool { get }
    var title: Localized { get }
    var description: Localized { get }
}
