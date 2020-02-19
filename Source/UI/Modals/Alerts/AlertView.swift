//
//  AlertView.swift
//  Benji
//
//  Created by Benji Dodgson on 6/30/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class AlertView: View {

    @IBOutlet weak var dismissHitArea: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var buttonsContainer: UIView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomContentPadding: NSLayoutConstraint!

    private(set) var buttons: [LoadingButton] = []

    override func awakeFromNib() {
        super.awakeFromNib()

        self.set(backgroundColor: .clear)
        self.contentView.set(backgroundColor: .clear)
        self.cardView.roundCorners()
        self.cardView.set(backgroundColor: .background3)
        self.buttonsContainer.set(backgroundColor: .clear)
        self.showShadow(withOffset: 5)

        // Shrink the card height for small screens so the UI isn't crowded
        if UIScreen.main.isSmallerThan(screenSize: .phoneMedium) {
            self.heightConstraint.constant = UIScreen.main.bounds.height * 0.35
        }
    }

    func configure(buttons: [LoadingButton]) {

        runMain {
            self.buttons.removeAllFromSuperview(andRemoveAll: true)
            self.buttons = buttons
            self.buttons.forEach { button in
                self.buttonsContainer.addSubview(button)
            }
            // HACK: Sometimes the buttons are not displayed
            self.layoutNow()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard let buttonsContainer = self.buttonsContainer else { return }

        var yOffset: CGFloat = 0
        for (index, subview) in buttonsContainer.subviews.enumerated() {
            guard let button = subview as? UIButton else { return }
            button.frame = CGRect(x: 0, y: yOffset, width: self.buttonsContainer.width, height: 60)
            button.layer.cornerRadius = Theme.contentOffset
            yOffset = (button.height + 10) * CGFloat(index + 1)
        }

        self.buttonsHeightConstraint.constant = yOffset
    }
}
