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
    let cellWidth: CGFloat
    let bubbleView = View()

    init(with message: Messageable,
         cellWidth: CGFloat) {

        self.message = message
        self.cellWidth = cellWidth

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

        self.messageTextView.set(text: self.message.text, messageContext: self.message.context)

        let backgroundColor: Color = self.message.isFromCurrentUser ? .lightPurple : .purple
        self.bubbleView.set(backgroundColor: backgroundColor)
        self.view.addSubview(self.messageTextView)
        self.messageTextView.setSize(withWidth: self.cellWidth - 20)

        self.preferredContentSize.height = self.messageTextView.height + 20
        self.preferredContentSize.width = self.cellWidth
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.messageTextView.centerOnXAndY()
    }
}
