//
//  Button.swift
//  Benji
//
//  Created by Benji Dodgson on 2/4/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TMROLocalization

enum ButtonStyle {
    case rounded(color: Color, text: Localized)
    case normal(color: Color, text: Localized)
    case icon(image: UIImage)
}

class Button: UIButton {

    var didSelect: CompletionOptional = nil
    private let selectionImpact = UIImpactFeedbackGenerator()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializeSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initializeSubviews() {
        self.onTap { [unowned self] (tap) in
            self.selectionImpact.impactOccurred()
            self.didSelect?()
        }
    }

    //Sets text font, color and background color
    func set(style: ButtonStyle,
             shouldRound: Bool = true,
             casingType: StringCasing = StringCasing.unchanged) {

        switch style {

        case .rounded(let color, let text), .normal(let color, let text):
            var localizedString = localized(text)

            localizedString = casingType.format(string: localizedString)

            let normalString = NSMutableAttributedString(string: localizedString)
            normalString.addAttribute(.font, value: FontType.smallBold.font)
            normalString.addAttribute(.kern, value: CGFloat(2))

            let highlightedString = NSMutableAttributedString(string: localizedString)
            highlightedString.addAttribute(.font, value: FontType.smallBold.font)
            highlightedString.addAttribute(.kern, value: CGFloat(2))

            normalString.addAttribute(.foregroundColor, value: Color.white.color)
            highlightedString.addAttribute(.foregroundColor, value: Color.white.color)
            self.setBackground(color: color.color, forUIControlState: .normal)
            self.setBackground(color: color.highlightColor.color, forUIControlState: .highlighted)

            // Emojis wont show correctly with attributes
            if localizedString.getEmojiRanges().count > 0 {
                self.setTitle(localizedString, for: .normal)
                self.setTitle(localizedString, for: .highlighted)
            } else {
                self.setAttributedTitle(normalString, for: .normal)
                self.setAttributedTitle(highlightedString, for: .highlighted)
            }

        case .icon(let image):
            self.setBackgroundImage(image, for: state)
        }

        if shouldRound {
            self.layer.cornerRadius = Theme.cornerRadius
            self.layer.masksToBounds = true
        }
    }

    func setBackground(color: UIColor, forUIControlState state: UIControl.State) {
        self.setBackgroundImage(UIImage.imageWithColor(color: color), for: state)
    }

    func setSize(with width: CGFloat) {
        self.size = CGSize(width: width - (Theme.contentOffset * 2), height: 60)
    }

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first, let view = touch.view, let button = view as? UIButton {
            button.scaleDown()
        }
    }

    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if let touch = touches.first, let view = touch.view, let button = view as? UIButton {
            button.scaleUp()
        }
    }

    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        if let touch = touches.first, let view = touch.view, let button = view as? UIButton {
            button.scaleUp()
        }
    }
}
