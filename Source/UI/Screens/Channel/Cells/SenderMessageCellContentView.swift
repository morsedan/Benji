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

    override func awakeFromNib() {
        super.awakeFromNib()

        self.textView.translatesAutoresizingMaskIntoConstraints = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard let textView = self.textView else { return }

        if textView.numberOfLines == 1 {
            textView.layer.cornerRadius = self.textView.halfHeight
        } else {
            textView.roundCorners()
        }
    }
}
