//
//  ChannelPurposeViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 9/8/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ChannelPurposeViewController: ViewController {

    let offset: CGFloat = 20

    let textFieldTitleLabel = RegularBoldLabel()
    let textField = PurposeTitleTextField()
    let textFieldDescriptionLabel = XSmallLabel()

    let textViewTitleLabel = RegularBoldLabel()
    let textView = PurposeDescriptionTextView()

    let createButton = LoadingButton()

    let favoritesLabel = RegularBoldLabel()
    let collectionView = FavoritesCollectionView()
    lazy var favoritesVC = FavoritesViewController(with: self.collectionView)

    override func initializeViews() {
        super.initializeViews()

        self.view.set(backgroundColor: .background3)

        self.view.addSubview(self.textFieldTitleLabel)
        self.textFieldTitleLabel.set(text: "Channel Name", stringCasing: .unchanged)
        self.view.addSubview(self.textField)
        self.textField.set(backgroundColor: .background2)
        self.textField.roundCorners()

        self.view.addSubview(self.textFieldDescriptionLabel)
        self.textFieldDescriptionLabel.set(text: "Names must be lowercase, without spaces or periods, and can't be longer than 80 characters.", color: .lightPurple)

        self.view.addSubview(self.textViewTitleLabel)
        self.textViewTitleLabel.set(text: "Purpose (Optional)", stringCasing: .unchanged)
        self.view.addSubview(self.textView)
        self.textView.set(backgroundColor: .background2)
        self.textView.roundCorners()
        self.textView.delegate = self

        self.textField.onTextChanged = { [unowned self] in
            self.handleTextChange()
        }

        self.view.addSubview(self.createButton)
        self.createButton.set(style: .normal(color: .blue, text: "CREATE")) { [unowned self] in
            self.createTapped()
        }
        self.createButton.isEnabled = false

        self.view.addSubview(self.favoritesLabel)
        self.favoritesLabel.set(text: "Favorites", stringCasing: .unchanged)
        self.addChild(viewController: self.favoritesVC)
        self.favoritesVC.view.set(backgroundColor: .background2)
        self.favoritesVC.view.roundCorners()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let width = self.view.width - (self.offset * 2)

        self.textFieldTitleLabel.setSize(withWidth: width)
        self.textFieldTitleLabel.top = 30
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

        self.favoritesLabel.setSize(withWidth: width)
        self.favoritesLabel.top = self.textView.bottom + 30
        self.favoritesLabel.left = self.offset

        self.favoritesVC.view.size = CGSize(width: width, height: 150)
        self.favoritesVC.view.top = self.favoritesLabel.bottom + 10
        self.favoritesVC.view.left = self.offset

        self.createButton.size = CGSize(width: width, height: 40)
        self.createButton.top = self.favoritesVC.view.bottom + 30
        self.createButton.centerOnX()
    }

    private func handleTextChange() {
        guard let text = self.textField.text else { return }

        self.createButton.isEnabled = !text.isEmpty
    }

    private func createTapped() {

    }
}

extension ChannelPurposeViewController: UITextViewDelegate {

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
