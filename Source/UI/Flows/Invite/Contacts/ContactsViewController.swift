//
//  ContactsViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 6/30/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Contacts

class ContactsViewController: CollectionViewController<ContactCell, ContactsCollectionViewManager>, ScrolledModalControllerPresentable, KeyboardObservable {
    
    var didDismiss: (() -> Void)?
    var didUpdateHeight: ((CGRect, TimeInterval, UIView.AnimationCurve) -> ())?

    var topMargin: CGFloat {
        guard let top = UIWindow.topWindow() else { return 120 }

        return top.size.height * 0.4
    }

    var scrollView: UIScrollView? {
        return self.collectionView
    }

    var scrollingEnabled: Bool {
        return true
    }

    init() {
        let collectionView = ContactsCollectionView()
        super.init(with: collectionView)

        collectionView.emptyView.button.onTap { [unowned self] (tap) in
            self.getAuthorizationStatus()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerKeyboardEvents()

        self.view.set(backgroundColor: .background3)

        ContactsManager.shared.getAuthorizationStatus { [unowned self] (authorizationStatus) in
            guard authorizationStatus == .authorized else { return }
            self.getContacts()
        }
    }

    func getAuthorizationStatus() {
        ContactsManager.shared.getAuthorizationStatus { [unowned self] (authorizationStatus) in
            switch authorizationStatus {
            case .notDetermined, .restricted, .denied:
                runMain {
                    self.askForAuthorization(status: authorizationStatus)
                }
            case .authorized:
                self.getContacts()
            @unknown default:
                runMain {
                    self.askForAuthorization(status: authorizationStatus)
                }
            }
        }
    }

    func getContacts() {
        runMain {
            self.collectionView.activityIndicator.startAnimating()
        }

        ContactsManager.shared.getContacts { [weak self] (contacts: [CNContact]) in
            guard let `self` = self else { return }

            self.collectionView.activityIndicator.stopAnimating()
            self.sort(contacts: contacts)
        }
    }

    private func sort(contacts: [CNContact]) {
        self.collectionViewManager.set(newItems: contacts)
    }

    private func askForAuthorization(status: CNAuthorizationStatus) {

        let contactModal = ContactAuthorizationAlertController(status: status)
        contactModal.onAuthorization = { [unowned self] (result) in
            switch result {
            case .denied:
                self.dismiss(animated: true) {
                    self.didDismiss?()
                }
            case .authorized:
                self.dismiss(animated: true) {
                    self.getContacts()
                }
            }
        }

        self.present(contactModal, animated: true)
    }

    func handleKeyboard(frame: CGRect, with animationDuration: TimeInterval, timingCurve: UIView.AnimationCurve) {
        self.didUpdateHeight?(frame, animationDuration, timingCurve)
    }
}
