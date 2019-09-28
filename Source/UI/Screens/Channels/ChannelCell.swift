//
//  ChannelCell.swift
//  Benji
//
//  Created by Benji Dodgson on 2/3/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient

class ChannelCell: UICollectionViewCell, DisplayableCell {

    typealias ItemType = ChannelType
    
    let content = ChannelCellContentView()
    private let selectionFeedback = UIImpactFeedbackGenerator(style: .light)

    func configure(with item: ChannelType?) {
        guard let type = item else { return }

        self.contentView.removeAllSubviews()
        self.contentView.addSubview(self.content)

        self.content.configure(with: type)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.content.size = CGSize(width: self.contentView.width * 0.9, height: self.contentView.height)
        self.content.centerOnXAndY()
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
