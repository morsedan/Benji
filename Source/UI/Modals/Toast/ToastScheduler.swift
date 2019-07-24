//
//  ToastScheduler.swift
//  Benji
//
//  Created by Benji Dodgson on 7/23/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient

enum ToastType {
    case systemMessage(SystemMessage)
    case message(TCHMessage)
}

class ToastScheduler {
    static let shared = ToastScheduler()

    func schedule(toastType: ToastType) {
        var toast: Toast?
        switch toastType {
        case .systemMessage(let message):
            toast = self.createSystemMessageToast(for: message)
        case .message(_):
            break
        }

        if let toast = toast {
            ToastQueue.shared.add(toast: toast)
        }
    }

    private func createSystemMessageToast(for systemMessage: SystemMessage) -> Toast? {
        let button = LoadingButton()
        button.set(style: .rounded(color: .background3, text: "VIEW")) {

        }
        return Toast(id: systemMessage.id + "system_message",
                     analyticsID: "ToastSystemMessage",
                     priority: 1,
                     title: systemMessage.body,
                     button: button,
                     displayable: systemMessage.avatar)
    }
}
