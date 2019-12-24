//
//  DetailBarView.swift
//  Benji
//
//  Created by Benji Dodgson on 12/24/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class DetailBarView: View, UITextFieldDelegate {

    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    private(set) var titleTitleTextField = TextField()
    private(set) var descriptionTextField = TextField()
    private(set) var stackedAvatarView = StackedAvatarView()

    override func initializeSubviews() {
        super.initializeSubviews()

        self.addSubview(self.blurView)

        self.addSubview(self.titleTitleTextField)

        let attributedString = AttributedString("name", fontType: .regularSemiBold, color: .white)
        self.titleTitleTextField.setPlaceholder(attributed: attributedString)
        self.titleTitleTextField.setDefaultAttributes(style: StringStyle(font: .regularBold, color: .white))
        self.titleTitleTextField.delegate = self
        self.titleTitleTextField.onTextChanged = { [unowned self] in

        }
        self.titleTitleTextField.onEditingEnded = { [unowned self] in

        }

        self.addSubview(self.descriptionTextField)
        self.descriptionTextField.setDefaultAttributes(style: StringStyle(font: .smallSemiBold, color: .background4))
        let attributedDescription = AttributedString("description", fontType: .smallSemiBold, color: .background3)
        self.descriptionTextField.setPlaceholder(attributed: attributedDescription)
        self.descriptionTextField.delegate = self
        self.descriptionTextField.onTextChanged = { [unowned self] in

        }
        self.descriptionTextField.onEditingEnded = { [unowned self] in

        }

        self.addSubview(self.stackedAvatarView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.blurView.frame = self.bounds

        let maxWidth = self.width - 44
        self.titleTitleTextField.size = CGSize(width: maxWidth, height: 40)
        self.titleTitleTextField.left = 16
        self.titleTitleTextField.bottom = self.centerY - 4

        self.descriptionTextField.size = CGSize(width: maxWidth, height: 40)
        self.descriptionTextField.left = 16
        self.descriptionTextField.top = self.centerY + 4

        self.stackedAvatarView.height = 40
        self.stackedAvatarView.right = self.width - 16
        self.stackedAvatarView.centerOnY()
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {

    }
}
