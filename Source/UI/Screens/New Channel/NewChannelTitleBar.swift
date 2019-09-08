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

        let defaultAttributed = AttributedString(" ", fontType: .regularBold, color: .white)
        self.textField.setPlaceholder(attributed: defaultAttributed)
        self.textField.returnKeyType = .done
        self.addSubview(self.textField)
        let attributed = AttributedString("Add Title", fontType: .regularBold, color: .white)
        self.textField.setPlaceholder(attributed: attributed)
        self.textField.onTextChanged = { [unowned self] in
            self.handleTextChange()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.textField.size = CGSize(width: self.width, height: 40)
        self.textField.left = 0
        self.textField.bottom = self.height - 10 

        self.textField.setBottomBorder(color: .white)
    }

    private func handleTextChange() {
        guard let text = self.textField.text else { return }

    }
}
