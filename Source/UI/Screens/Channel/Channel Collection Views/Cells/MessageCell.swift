//
//  ChannelCell.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient

class MessageCell: UICollectionViewCell {

    let avatarView = AvatarView()
    let bubbleView = View()
    let textView = MessageTextView()
    private let selectionFeedback = UIImpactFeedbackGenerator(style: .light)
    var didTapMessage: () -> Void = {}

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.initializeViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.initializeViews()
    }

    private func initializeViews() {
        self.contentView.addSubview(self.avatarView)
        self.contentView.addSubview(self.bubbleView)
        self.contentView.addSubview(self.textView)

        let view = UIView(frame: self.bounds)
        view.set(backgroundColor: .background2)
        self.backgroundView = view

        self.textView.gestureRecognizers?.forEach({ (gesture) in
            if gesture is UITapGestureRecognizer {
                self.bubbleView.removeGestureRecognizer(gesture)
            }
        })

        self.textView.onTap { (tap) in
            UIView.animate(withDuration: Theme.animationDuration, delay: 0, options: [.curveEaseIn, .autoreverse], animations: {
                self.bubbleView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }, completion: nil)

            self.didTapMessage()
        }
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        guard let attributes = layoutAttributes as? ChannelCollectionViewLayoutAttributes else { return }

        self.layoutContent(with: attributes)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.bubbleView.layer.borderColor = nil
        self.bubbleView.layer.borderWidth = 0
        
        self.textView.text = nil
    }

    func configure(with message: Messageable) {

        if !message.isFromCurrentUser {
            self.avatarView.set(avatar: message.avatar)
        }
        self.textView.set(text: message.text)

        self.handleStatus(for: message)
        self.handleIsConsumed(for: message)
    }

    private func handleStatus(for message: Messageable) {

        if message.isFromCurrentUser {
            switch message.status {
            case .sent:
                break
            case .delivered:
                break
            case .unknown:
                break
            case .error:
                break
            }
        } else {
            switch message.status {
            case .sent:
                break
            case .delivered:
                break
            case .unknown:
                break
            case .error:
                break
            }
        }
    }

    private func handleIsConsumed(for message: Messageable) {

        self.bubbleView.set(backgroundColor: message.color)

        if !message.isFromCurrentUser, !message.isConsumed {
            self.bubbleView.set(backgroundColor: message.context.color)
            self.bubbleView.layer.borderColor = Color.purple.color.cgColor
            self.bubbleView.layer.borderWidth = 2
        }
    }

    private func layoutContent(with attributes: ChannelCollectionViewLayoutAttributes) {

        self.avatarView.frame = attributes.attributes.avatarFrame
        self.textView.frame = attributes.attributes.textViewFrame
        self.bubbleView.frame = attributes.attributes.bubbleViewFrame
        self.bubbleView.layer.maskedCorners = attributes.attributes.maskedCorners
        self.bubbleView.roundCorners()
    }

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.selectionFeedback.impactOccurred()
        self.bubbleView.scaleDown()
    }

    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.bubbleView.scaleUp()
    }

    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.bubbleView.scaleUp()
    }
}
