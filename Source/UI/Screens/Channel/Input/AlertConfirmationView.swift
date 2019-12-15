//
//  AlertConfirmationView.swift
//  Benji
//
//  Created by Benji Dodgson on 10/31/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TMROLocalization

class AlertConfirmationView: View {

    private let label = XXSmallSemiBoldLabel()
    private let cancelButton = CancelButton()
    private var blurView = UIVisualEffectView(effect: nil)
    private let selectionFeedback = UIImpactFeedbackGenerator(style: .light)

    var text: Localized? {
        didSet {
            guard let text = self.text else { return }
            self.label.set(text: text, color: .white, alignment: .left, stringCasing: .unchanged)
            self.layoutNow()
        }
    }

    var keyboardAppearance: UIKeyboardAppearance? {
        didSet {
            if let appearance = self.keyboardAppearance, appearance == .light {
                self.blurView.effect = nil
            } else {
                self.blurView.effect = UIBlurEffect(style: .dark)
            }
            self.set(backgroundColor: .keyboardBackground)
        }
    }

    var didCancel: CompletionOptional = nil

    override func initializeSubviews() {
        super.initializeSubviews()

        self.set(backgroundColor: .keyboardBackground)

        self.addSubview(self.blurView)
        self.addSubview(self.label)
        self.addSubview(self.cancelButton)
        self.cancelButton.onTap { [unowned self] (tap) in
            self.selectionFeedback.impactOccurred()
            self.didCancel?()
        }
    }

    func setAlertMessage(for avatars: [Avatar]) {
        var arguments: [String] = []
        for (index, avatar) in avatars.enumerated() {
            if avatar.userObjectID != User.current()?.objectId, let handle = avatar.handle, !handle.isEmpty {
                if avatars.count == 1 {
                    arguments.append(handle + " ")
                } else if index + 1 == avatars.count, arguments.count > 1 {
                    arguments.append(" and" + handle + " ")
                } else {
                    arguments.append(handle + ", ")
                }
            }
        }

        if arguments.isEmpty {
            arguments.append("others ")
        }
        self.text = LocalizedString(id: "", arguments: arguments, default: "Swipe up to alert @(handle)of this message and be notified when it is read.")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.cancelButton.centerOnY()
        self.cancelButton.right = self.width - Theme.contentOffset

        let maxWidth = self.width - (Theme.contentOffset * 3) - 44
        self.label.setSize(withWidth: maxWidth)
        self.label.left = Theme.contentOffset
        self.label.top = 8
    }
}
