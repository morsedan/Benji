//
//  PurposeViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class PurposeViewController: ViewController {

    let offset: CGFloat = 20

    let textFieldTitleLabel = RegularBoldLabel()
    let textField = PurposeTitleTextField()
    let textFieldDescriptionLabel = XXSmallSemiBoldLabel()

    let textViewTitleLabel = RegularBoldLabel()
    let textView = PurposeDescriptionTextView()
    let textViewDescription = XXSmallSemiBoldLabel()

    let createButton = NewChannelButton()

    override func initializeViews() {
        super.initializeViews()

        self.view.addSubview(self.textFieldTitleLabel)
        self.textFieldTitleLabel.set(text: "Conversation", stringCasing: .unchanged)
        self.view.addSubview(self.textField)
        self.textField.set(backgroundColor: .background3)
        self.textField.roundCorners()

        self.view.addSubview(self.textFieldDescriptionLabel)
        self.textFieldDescriptionLabel.set(text: "Names must be lowercase, without spaces or periods, and can't be longer than 80 characters.")

        self.view.addSubview(self.textViewTitleLabel)
        self.textViewTitleLabel.set(text: "Purpose", stringCasing: .unchanged)
        self.view.addSubview(self.textView)
        self.textView.set(backgroundColor: .background3)
        self.textView.roundCorners()
        self.textView.delegate = self

        self.view.addSubview(self.textViewDescription)
        self.textViewDescription.set(text: "Briefly describe the purpose of this conversation.")

        self.textField.onTextChanged = { [unowned self] in
            self.handleTextChange()
        }

        self.textField.delegate = self

        self.view.addSubview(self.createButton)
        self.createButton.onTap { [unowned self] (tap) in
            self.createTapped()
        }

        self.createButton.isEnabled = false
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

        self.textFieldDescriptionLabel.setSize(withWidth: width)
        self.textFieldDescriptionLabel.left = self.offset
        self.textFieldDescriptionLabel.top = self.textField.bottom + 10

        self.textViewTitleLabel.setSize(withWidth: width)
        self.textViewTitleLabel.top = self.textFieldDescriptionLabel.bottom + 30
        self.textViewTitleLabel.left = self.offset

        self.textView.size = CGSize(width: width, height: 120)
        self.textView.top = self.textViewTitleLabel.bottom + 10
        self.textView.left = self.offset

        self.textViewDescription.setSize(withWidth: width)
        self.textViewDescription.left = self.offset
        self.textViewDescription.top = self.textView.bottom + 10
    }

    private func handleTextChange() {
        guard let text = self.textField.text else { return }
        self.textField.text = text.lowercased()
        self.updateCreateButton()
    }

    private func updateCreateButton() {
        guard let text = self.textField.text else {
            self.createButton.isEnabled = false
            return
        }


        self.createButton.isEnabled = !text.isEmpty
    }

    private func createTapped() {
        guard let title = self.textField.text,
            let description = self.textView.text else { return }

      //  self.createChannel(with: user.objectId!, title: title, description: description)
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
}

extension PurposeViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if string == " " || string == "." {
            return false
        }

        if string.count > 80 {
            return false
        }

        return true
    }
}
