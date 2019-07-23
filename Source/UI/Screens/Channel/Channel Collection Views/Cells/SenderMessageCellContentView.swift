//
//  SenderMessageCellContentView.swift
//  Benji
//
//  Created by Benji Dodgson on 7/3/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class SenderMessageCellContentView: View {

    @IBOutlet weak var textView: MessageTextView!
    @IBOutlet weak var bubbleView: View!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.bubbleView.translatesAutoresizingMaskIntoConstraints = false
        self.textView.translatesAutoresizingMaskIntoConstraints = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard let textView = self.textView else { return }

        if textView.numberOfLines == 1 {
            self.bubbleView.layer.cornerRadius = self.bubbleView.halfHeight
        } else {
            self.bubbleView.roundCorners()
        }
    }
}
