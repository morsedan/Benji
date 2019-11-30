//
//  AlertConfirmationView.swift
//  Benji
//
//  Created by Benji Dodgson on 10/31/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class AlertConfirmationView: View {

    private let confirmButton = Button()
    private let cancelButton = Button()
    private var blurView = UIVisualEffectView(effect: nil)
    private let selectionFeedback = UIImpactFeedbackGenerator(style: .light)

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

    var didConfirm: CompletionHandler?

    override func initializeSubviews() {
        super.initializeSubviews()

        self.set(backgroundColor: .keyboardBackground)

        self.addSubview(self.blurView)
        self.addSubview(self.confirmButton)
        self.confirmButton.set(style: .rounded(color: .red, text: "Confirm"))
        self.confirmButton.onTap { [unowned self] (tap) in
            self.selectionFeedback.impactOccurred()
            self.didConfirm?(true, nil)
        }
        self.cancelButton.set(style: .rounded(color: .blue, text: "Cancel"))
        self.addSubview(self.cancelButton)
        self.cancelButton.onTap { [unowned self] (tap) in
            self.selectionFeedback.impactOccurred()
            self.didConfirm?(false, nil)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.cancelButton.size = CGSize(width: 90, height: 34)
        self.cancelButton.centerOnY()
        self.cancelButton.right = self.width - Theme.contentOffset
        self.cancelButton.roundCorners()

        self.confirmButton.size = CGSize(width: 90, height: 34)
        self.confirmButton.centerOnY()
        self.confirmButton.right = self.cancelButton.left - Theme.contentOffset
        self.confirmButton.roundCorners()
    }
}
