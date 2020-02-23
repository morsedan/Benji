//
//  MessagePreviewViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 1/22/20.
//  Copyright © 2020 Benjamin Dodgson. All rights reserved.
//

import Foundation

class MessagePreviewViewController: ViewController {

    let message: Messageable
    let messageTextView = MessageTextView()
    let channelAttributes: ChannelCollectionViewLayoutAttributes
    let bubbleView = View()

    init(with message: Messageable,
         attributes: ChannelCollectionViewLayoutAttributes) {

        self.message = message
        self.channelAttributes = attributes

        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = self.bubbleView
    }

    override func initializeViews() {
        super.initializeViews()

        self.view.addSubview(self.messageTextView)
        self.messageTextView.set(text: self.message.text, messageContext: self.message.context)
        self.handleIsConsumed(for: self.message)

        self.messageTextView.size = self.channelAttributes.attributes.textViewFrame.size

        self.preferredContentSize = self.channelAttributes.attributes.bubbleViewFrame.size
    }

    private func handleIsConsumed(for message: Messageable) {

        self.bubbleView.set(backgroundColor: message.color)

        if !message.isFromCurrentUser, !message.isConsumed, message.context != .status {

            if !message.isFromCurrentUser, message.context == .casual {
                self.bubbleView.layer.borderColor = Color.purple.color.cgColor
            } else {
                self.bubbleView.layer.borderColor = message.context.color.color.cgColor
            }

            self.bubbleView.layer.borderWidth = 2
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.messageTextView.centerOnXAndY()
    }
}
