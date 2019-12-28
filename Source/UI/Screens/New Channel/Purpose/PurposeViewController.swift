//
//  PurposeViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TMROLocalization

class PurposeViewController: ViewController {

    let offset: CGFloat = 20

    let textFieldTitleLabel = RegularBoldLabel()
    let textField = PurposeTitleTextField()

    let textViewTitleLabel = RegularBoldLabel()
    let textView = PurposeDescriptionTextView()

    let purposeAccessoryView = PurposeInputAccessoryView()

    var totalHeight: CGFloat = 284

    var textFieldDidBegin: CompletionOptional = nil
    var textFieldDidEnd: CompletionOptional = nil

    var textViewDidBegin: CompletionOptional = nil
    var textViewDidEnd: CompletionOptional = nil

    var textFieldTextDidChange: (String) -> Void = { _ in }

    override func initializeViews() {
        super.initializeViews()

        self.view.addSubview(self.textFieldTitleLabel)
        self.textFieldTitleLabel.set(text: "Name", stringCasing: .unchanged)
        self.view.addSubview(self.textField)
        self.textField.set(backgroundColor: .background3)
        self.textField.roundCorners()

        self.view.addSubview(self.textViewTitleLabel)
        self.textViewTitleLabel.set(text: "Purpose", stringCasing: .unchanged)
        self.view.addSubview(self.textView)
        self.textView.set(backgroundColor: .background3)
        self.textView.roundCorners()
        self.textView.delegate = self

        self.textField.onTextChanged = { [unowned self] in
            guard let text = self.textField.text else { return }
            self.textFieldTextDidChange(text)
            self.purposeAccessoryView.textColor = text.isEmpty ? .red : .white
        }

        self.textField.delegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let width = self.view.width - (self.offset * 2)

        self.textFieldTitleLabel.setSize(withWidth: width)
        self.textFieldTitleLabel.top = 20
        self.textFieldTitleLabel.left = self.offset

        self.textField.size = CGSize(width: width, height: 40)
        self.textField.left = self.offset
        self.textField.top = self.textFieldTitleLabel.bottom + 10

        self.textViewTitleLabel.setSize(withWidth: width)
        self.textViewTitleLabel.top = self.textField.bottom + 30
        self.textViewTitleLabel.left = self.offset

        self.textView.size = CGSize(width: width, height: 120)
        self.textView.top = self.textViewTitleLabel.bottom + 10
        self.textView.left = self.offset
    }
}

extension PurposeViewController: UITextViewDelegate {

    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {

        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }

        return true
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        self.purposeAccessoryView.showAccessoryForDescription(textView: textView)
        self.textViewDidBegin?()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        self.textViewDidEnd?()
    }
}

extension PurposeViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.purposeAccessoryView.showAccessoryForName(textField: textField)
        self.textFieldDidBegin?()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.textFieldDidEnd?()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if string == " " || string == "." {
            return false
        }

        if string.count > 80 {
            return false
        }

        if let _ = string.rangeOfCharacter(from: .uppercaseLetters) {
            return false
        }

        return true
    }
}
