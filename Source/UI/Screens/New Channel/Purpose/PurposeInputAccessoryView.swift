//
//  PurposeInputAccessoryView.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TMROLocalization

class PurposeInputAccessoryView: TextInputAccessoryView {

    func showAccessoryForName(textField: UITextField) {
        textField.inputAccessoryView = nil
        textField.reloadInputViews()

        self.frame = CGRect(x: 0,
                            y: 0,
                            width: UIScreen.main.bounds.width,
                            height: 60)
        self.keyboardAppearance = textField.keyboardAppearance
        self.text = LocalizedString(id: "", arguments: [], default: "Names must be lowercase, without spaces or periods, and can't be longer than 80 characters.")
        textField.inputAccessoryView = self
        textField.reloadInputViews()

        self.didCancel = {
            textField.resignFirstResponder()
        }
    }

    func showAccessoryForDescription(textView: UITextView) {
        textView.inputAccessoryView = nil
        textView.reloadInputViews()

        self.frame = CGRect(x: 0,
                            y: 0,
                            width: UIScreen.main.bounds.width,
                            height: 60)
        self.keyboardAppearance = textView.keyboardAppearance
        self.text = LocalizedString(id: "",arguments: [], default: "Briefly describe the purpose of this conversation. This will be added to initial message for the conversation.")
        textView.inputAccessoryView = self
        textView.reloadInputViews()

        self.didCancel = {
            textView.resignFirstResponder()
        }
    }
}

