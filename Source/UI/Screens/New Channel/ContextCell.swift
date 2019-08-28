//
//  ContextCell.swift
//  Benji
//
//  Created by Benji Dodgson on 8/27/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ContextCell: UICollectionViewCell {
    static let reuseID = "ContextCell"

    let label = RegularSemiBoldLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialize() {
        self.contentView.addSubview(self.label)
    }

    func configure(with context: MessageContext) {
        self.label.set(text: context.text,
                       color: context.color,
                       alignment: .center,
                       stringCasing: .capitalized)
        self.contentView.backgroundColor = context.color.color.withAlphaComponent(0.5)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.label.setSize(withWidth: self.contentView.proportionalWidth)
        self.label.centerOnXAndY()
    }
}
