//
//  File.swift
//  Benji
//
//  Created by Benji Dodgson on 8/27/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class NewChannelSectionHeader: UICollectionReusableView {

    static let reuseID = "NewChannelSectionHeader"

    let label = RegularBoldLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializeViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeViews()
    }

    private func initializeViews() {
        self.addSubview(self.label)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.label.sizeToFit()
        self.label.centerOnXAndY()
    }
}
