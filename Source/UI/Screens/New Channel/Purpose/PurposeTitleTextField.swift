//
//  PurposeTitleLabel.swift
//  Benji
//
//  Created by Benji Dodgson on 9/8/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class PurposeTitleTextField: TextField {

    let label = Label()

    override func initialize() {
        super.initialize()

        self.addSubview(self.label)

        let defaultAttributed = AttributedString(" ", fontType: .regularBold, color: .white)
        self.setPlaceholder(attributed: defaultAttributed)
        self.returnKeyType = .done
        self.autocapitalizationType = .none 
        let attributed = AttributedString("Add Title", fontType: .regularBold, color: .white)
        self.setPlaceholder(attributed: attributed)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        
    }
}
