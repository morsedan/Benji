//
//  OnboardingContent.swift
//  Benji
//
//  Created by Benji Dodgson on 1/14/20.
//  Copyright © 2020 Benjamin Dodgson. All rights reserved.
//

import Foundation

enum OnboardingContent: Equatable {
    
    case reservation(ReservationViewController)
    case phone(LoginPhoneViewController)
    case code(LoginCodeViewController)
    case name(LoginNameViewController)
    case photo(LoginProfilePhotoViewController)

    var vc: UIViewController {
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

    var showBackButton: Bool {
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
