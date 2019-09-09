//
//  ChannelPurposeViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 9/8/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ChannelPurposeViewController: ViewController, KeyboardObservable {

    let offset: CGFloat = 20

    let textFieldTitleLabel = RegularSemiBoldLabel()
    let textField = PurposeTitleTextField()
    let textFieldDescriptionLabel = XSmallLabel()

    let textViewTitleLabel = RegularSemiBoldLabel()
    let textView = PurposeDescriptionTextView()

    override func initializeViews() {
        super.initializeViews()

        self.registerKeyboardEvents()
        self.view.set(backgroundColor: .background3)

        self.view.addSubview(self.textFieldTitleLabel)
        self.textFieldTitleLabel.set(text: "Channel Name", stringCasing: .unchanged)
        self.view.addSubview(self.textField)

        self.view.addSubview(self.textFieldDescriptionLabel)
        self.textFieldDescriptionLabel.set(text: "Names must be lowercase, without spaces or periods, and can't be longer than 80 characters.", color: .lightPurple)

        self.view.addSubview(self.textViewTitleLabel)
        self.textViewTitleLabel.set(text: "Purpose (Optional)", stringCasing: .unchanged)
        self.view.addSubview(self.textView)

        self.textField.onTextChanged = { [unowned self] in
            self.handleTextChange()
        }

        delay(0.5) {
            self.textField.becomeFirstResponder()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let width = self.view.width - (self.offset * 2)

        self.textFieldTitleLabel.setSize(withWidth: width)
        self.textFieldTitleLabel.top = 50
        self.textFieldTitleLabel.left = self.offset

        self.textField.size = CGSize(width: width, height: 40)
        self.textField.left = self.offset
        self.textField.top = self.textFieldTitleLabel.bottom + 10
        self.textField.setBottomBorder(color: .white)

        self.textFieldDescriptionLabel.setSize(withWidth: width)
        self.textFieldDescriptionLabel.left = self.offset
        self.textFieldDescriptionLabel.top = self.textField.bottom + 10

        self.textViewTitleLabel.setSize(withWidth: width)
        self.textViewTitleLabel.top = self.textFieldDescriptionLabel.bottom + 50
        self.textViewTitleLabel.left = self.offset

        self.textView.size = CGSize(width: width, height: 200)
        self.textView.top = self.textViewTitleLabel.bottom + 10
        self.textView.left = self.offset
    }

    private func handleTextChange() {
        guard let text = self.textField.text else { return }

    }

    func handleKeyboard(frame: CGRect, with animationDuration: TimeInterval, timingCurve: UIView.AnimationCurve) {

//        let newHeight = (self.view.height - self.titleBar.bottom - frame.size.height) * -1
//        var newFrame = frame
//        newFrame.size.height = newHeight
//        self.didUpdateHeight?(newFrame, animationDuration, timingCurve)
    }
}
