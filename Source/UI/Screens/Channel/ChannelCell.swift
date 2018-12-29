//
//  ChannelCell.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ChannelCell: UICollectionViewCell, DisplayableCell {
    var didSelect: ((IndexPath) -> Void)?
    var item: DisplayableCellItem?

    static let offset: CGFloat = 10

    let textView = TextView()

    func cellIsReadyForLayout() {
        guard let item = self.item else { return }

        self.contentView.addSubview(self.textView)

        let attributedString = AttributedString(item.text,
                                                font: .regular,
                                                size: 20,
                                                color: .white,
                                                kern: 0)

        self.textView.set(attributed: attributedString,
                          alignment: .left,
                          lineCount: 0,
                          lineBreakMode: .byWordWrapping,
                          stringCasing: .unchanged,
                          isEditable: false,
                          linkColor: .white)

        self.textView.set(backgroundColor: item.backgroundColor)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard let item = self.item else { return }

        let size = self.textView.getSize(withWidth: self.contentView.width * 0.9)
        self.textView.size = size
        if item.backgroundColor == .darkGray {
            self.textView.left = ChannelCell.offset
        } else {
            self.textView.right = self.contentView.width - ChannelCell.offset
        }
        self.textView.centerOnY()
        self.textView.roundCorners()
    }
}
