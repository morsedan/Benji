//
//  NewChannelTitleBar.swift
//  Benji
//
//  Created by Benji Dodgson on 8/28/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class NewChannelTitleBar: View {

    let titleTextField = TextField()

    override func initialize() {
        super.initialize()

        self.addSubview(self.titleTextField)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.titleTextField.size = CGSize(width: self.proportionalWidth, height: 40)
        self.titleTextField.centerOnXAndY()
    }
}
