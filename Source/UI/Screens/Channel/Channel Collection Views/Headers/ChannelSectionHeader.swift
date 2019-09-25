//
//  ChannelSectionHeader.swift
//  Benji
//
//  Created by Benji Dodgson on 7/20/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ChannelSectionHeader: UICollectionReusableView {

    let label = ChannelHeaderDateLabel()
    let underLineView = View()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializeViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeViews()
    }

    private func initializeViews() {
        self.addSubview(self.underLineView)
        self.underLineView.set(backgroundColor: .white)
        self.addSubview(self.label)
    }

    func configure(with date: Date) {
        self.label.set(date: date)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.label.setSize(withWidth: self.width)
        self.label.centerOnXAndY()

        self.underLineView.height = 1
        self.underLineView.width = self.label.width
        self.underLineView.top = self.label.bottom
        self.underLineView.centerOnX()
    }
}
