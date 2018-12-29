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
    static let font: Font = .regular

    let textView = TextView()

    func cellIsReadyForLayout() {
        guard let item = self.item else { return }

        self.contentView.addSubview(self.textView)

        let attributedString = AttributedString(item.text,
                                                font: .regular,
                                                size: 20,
                                                color: .white,
                                                kern: 0)

        let alignment: NSTextAlignment = item.backgroundColor == .darkGray ? .left : .right
        
        self.textView.set(attributed: attributedString,
                          alignment: alignment,
                          lineCount: 0,
                          lineBreakMode: .byWordWrapping,
                          stringCasing: .unchanged,
                          isEditable: false,
                          linkColor: .white)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.textView.width = self.contentView.width - ChannelCell.offset
        self.textView.height = self.contentView.height - ChannelCell.offset
        self.textView.centerOnXAndY()
    }
}
