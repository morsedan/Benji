//
//  MessageContext.swift
//  Benji
//
//  Created by Benji Dodgson on 6/29/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TMROLocalization

enum MessageContext: String, CaseIterable {

    case emergency
    case timeSensitive
    case convenient
    case casual

    var title: Localized {
        switch self {
        case .emergency:
            return "🚨 Emergency 🚨"
        case .timeSensitive:
            return " ⏰ Time-Sensitive ⏰"
        case .convenient:
            return " 🙋🏻‍♂️ When you have time 🙋🏻‍♂️"
        case .casual:
            return "Casual"
        }
    }

    var text: Localized {
        switch self {
        case .emergency:
            return "Emergency"
        case .timeSensitive:
            return "Time-Sensitive"
        case .convenient:
            return "When you have time"
        case .casual:
            return "Casual"
        }
    }

    var color: Color {
        switch self {
        case .emergency:
            return .red
        case .timeSensitive:
            return .orange
        case .convenient:
            return .green
        case .casual:
            return .teal
        }
    }
}
