//
//  ChannelsSectionHeader.swift
//  Benji
//
//  Created by Benji Dodgson on 9/28/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ChannelsSectionHeader: UICollectionReusableView {

    private let label = Display2Label()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializeViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initializeViews() {
        self.addSubview(self.label)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.label.setSize(withWidth: self.width * 0.9)
        self.label.centerOnXAndY()
    }

    func configure(with text: Localized) {
        self.label.set(text: text)
    }
}
