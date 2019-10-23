//
//  AutocompleteViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 10/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class SuggestionCollectionViewController: CollectionViewController<SuggestionCell, SuggestionCollectionViewManager>, Completable {

    var onDidComplete: ((Result<Void, ClientError>) -> Void)?
    var getCompletionResult: (() -> Result<Void, ClientError>)?

    private var blurView = UIVisualEffectView(effect: nil)

    private var suggestionCollectionView: SuggestionCollectionView? {
        return self.collectionView as? SuggestionCollectionView
    }

    unowned let textField: TextField

    init(parentController: UIViewController,
         textField: TextField) {

        self.textField = textField
        let collectionView = ContactsCollectionView()

        super.init(with: collectionView)

        parentController.addChild(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initializeViews() {
        super.initializeViews()

        self.view.addSubview(self.blurView)
        self.view.addSubview(self.collectionView)

        self.textField.onTextChanged = { [unowned self] in
            self.textFieldDidChange()
        }

        self.showAccessoryView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.blurView.frame = self.view.bounds
        self.collectionView.frame = self.view.bounds
    }

    func loadSuggestions(for text: String?) {
//        guard ContactsManager.shared.isContactsAccessAllowed else { return }
//        self.manager.filterText = text
    }

    func configure(with keyboardAppearance: UIKeyboardAppearance) {

        self.manager.keyboardAppearance = keyboardAppearance
        switch keyboardAppearance {
        case .light:
            self.blurView.effect = UIBlurEffect(style: .prominent)
        case .dark, .default:
            self.blurView.effect = UIBlurEffect(style: .dark)
        }

        self.collectionView.reloadData()
    }

    func textFieldDidChange() {
        self.showAccessoryView()
        self.loadSuggestions(for: self.textField.text)
    }

    func showAccessoryView() {
        guard self.textField.inputAccessoryView == nil else { return }
        self.configure(with: self.textField.keyboardAppearance)
        self.textField.inputAccessoryView = self.view
        self.textField.reloadInputViews()
    }

    private func hideAccessoryView() {
        self.textField.inputAccessoryView = nil
        self.textField.reloadInputViews()
    }

}
