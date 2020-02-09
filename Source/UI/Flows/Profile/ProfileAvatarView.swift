//
//  ProfileAvatarView.swift
//  Benji
//
//  Created by Benji Dodgson on 8/25/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse
import TwilioChatClient

class ProfileAvatarView: AvatarView {

    private let selectionFeedback = UIImpactFeedbackGenerator(style: .light)

    private var identifier: String?

    override func initializeSubviews() {
        super.initializeSubviews()

        self.subscribeToUpdates()
    }

    override func set(avatar: Avatar) {
        super.set(avatar: avatar)

        if let user = avatar as? PFUser {
            self.identifier = user.objectId
        } else if let memeber = avatar as? TCHMember {
            self.identifier = memeber.identity
        }
    }
    private func subscribeToUpdates() {

        ChannelManager.shared.clientUpdate.producer.on { [weak self] (update) in
            guard let `self` = self, let clientUpdate = update else { return }

            switch clientUpdate.status {
            case .connectionState(_):
                break
            case .userUpdate(let user, _ ):
                guard let current = self.identifier,
                    let userIdenetity = user.identity,
                    current == userIdenetity else { return }
                self.borderColor = user.isOnline() ? .green : .purple
            case .toastSubscribed:
                break
            case .toastRegistrationFailed(_):
                break
            case .error(_):
                break
            }
            }
            .start()
    }

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first, let view = touch.view {
            self.selectionFeedback.impactOccurred()
            view.scaleDown()
        }
    }

    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if let touch = touches.first, let view = touch.view {
            view.scaleUp()
        }
    }

    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        if let touch = touches.first, let view = touch.view {
            view.scaleUp()
        }
    }
}
