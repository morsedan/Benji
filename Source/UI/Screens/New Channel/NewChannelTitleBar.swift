//
//  NewChannelTitleBar.swift
//  Benji
//
//  Created by Benji Dodgson on 8/28/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class NewChannelTitleBar: View {

    let textField = TextField()

    override func initialize() {
        super.initialize()

        self.addSubview(self.textField)
        let attributed = AttributedString("Add Title", fontType: .regularBold, color: .white)
        self.textField.setPlaceholder(attributed: attributed)

    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.textField.size = CGSize(width: self.width, height: 40)
        self.textField.left = 0
        self.textField.bottom = self.height - 10 

        self.textField.setBottomBorder(color: .white)
    }
}
