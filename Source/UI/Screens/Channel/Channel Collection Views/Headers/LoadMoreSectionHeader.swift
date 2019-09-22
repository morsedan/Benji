//
//  LoadMoreSectionHeader.swift
//  Benji
//
//  Created by Benji Dodgson on 9/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient

class LoadMoreSectionHeader: UICollectionReusableView {

    private let descriptionLabel = XSmallLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializeViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeViews()
    }

    private func initializeViews() {

        self.addSubview(self.descriptionLabel)

        self.set(backgroundColor: .clear)
        self.descriptionLabel.set(text: "LOAD MORE",
                                  alignment: .center)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.descriptionLabel.setSize(withWidth: self.width)
        self.descriptionLabel.centerOnXAndY()
    }
}
