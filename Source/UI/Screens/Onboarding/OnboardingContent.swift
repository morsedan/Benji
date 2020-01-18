//
//  OnboardingContent.swift
//  Benji
//
//  Created by Benji Dodgson on 1/14/20.
//  Copyright © 2020 Benjamin Dodgson. All rights reserved.
//

import Foundation

enum OnboardingContent: Switchable {

    case reservation(ReservationViewController)
    case phone(PhoneViewController)
    case code(CodeViewController)
    case name(NameViewController)
    case photo(PhotoViewController)

    var viewController: UIViewController & Sizeable {
        switch self {
        case .reservation(let vc):
            return vc
        case .phone(let vc):
            return vc
        case .code(let vc):
            return vc
        case .name(let vc):
            return vc
        case .photo(let vc):
            return vc
        }
    }

    var shouldShowBackButton: Bool {
        switch self {
        case .reservation(_):
            return false
        case .phone(_):
            return true
        case .code(_):
            return true
        case .name(_):
            return false
        case .photo(_):
            return true
        }
    }
}
