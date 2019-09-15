//
//  TypingIndicatorCell.swift
//  Benji
//
//  Created by Benji Dodgson on 9/14/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

/// A subclass of `MessageCollectionViewCell` used to display the typing indicator.
class TypingIndicatorCell: UICollectionViewCell {

    // MARK: - Subviews

    var insets = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
    let typingBubble = TypingBubbleView()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializeViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeViews()
    }

    func initializeViews() {
        self.addSubview(self.typingBubble)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        if self.typingBubble.isAnimating {
            self.typingBubble.stopAnimating()
        }
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        self.typingBubble.frame = self.bounds.inset(by: self.insets)
    }
}
