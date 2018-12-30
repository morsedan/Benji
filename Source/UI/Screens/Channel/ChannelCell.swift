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
    let bubbleView = View()

    func cellIsReadyForLayout() {
        guard let item = self.item as? Message else { return }

        self.contentView.addSubview(self.bubbleView)
        self.contentView.addSubview(self.textView)
        let textColor: Color = item.isSender ? .lightGray : .darkGray

        let attributedString = AttributedString(item.text,
                                                font: .medium,
                                                size: 18,
                                                color: textColor,
                                                kern: 0)

        self.textView.set(attributed: attributedString,
                          alignment: .left,
                          lineCount: 0,
                          lineBreakMode: .byWordWrapping,
                          stringCasing: .unchanged,
                          isEditable: false,
                          linkColor: textColor)

        self.bubbleView.set(backgroundColor: item.backgroundColor)
        self.bubbleView.roundCorners()
    }
}
