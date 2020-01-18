//
//  TextEntryField.swift
//  Benji
//
//  Created by Benji Dodgson on 1/18/20.
//  Copyright © 2020 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TMROLocalization

class TextEntryField: View, Sizeable {

    private(set) var textField: UITextField
    private let titleLabel = SmallBoldLabel()
    private let title: Localized

    init(with textField: UITextField, title: Localized) {
        self.textField = textField
        self.title = title
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initializeSubviews() {
        super.initializeSubviews()

        self.addSubview(self.titleLabel)
        self.titleLabel.set(text: self.title, stringCasing: .unchanged)
        self.addSubview(self.textField)
        self.textField.set(backgroundColor: .background3)
        self.textField.roundCorners()
    }

    func getHeight(for width: CGFloat) -> CGFloat {

        self.titleLabel.setSize(withWidth: width)
        self.titleLabel.top = 0
        self.titleLabel.left = 0

        self.textField.size = CGSize(width: width, height: 40)
        self.textField.left = 0
        self.textField.top = self.titleLabel.bottom + 10

        return self.textField.bottom
    }
}
