//
//  ProfilePhotoViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 2/1/20.
//  Copyright © 2020 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TMROLocalization

enum PhotoContentType: Switchable {

    case photo(PhotoViewController)

    var viewController: UIViewController & Sizeable {
        switch self {
        case .photo(let vc):
            return vc
        }
    }

    var shouldShowBackButton: Bool {
        return false
    }
}

protocol ProfilePhotoViewControllerDelegate: class {
    func profilePhotoViewControllerDidFinish(_ controller: ProfilePhotoViewController)
}

class ProfilePhotoViewController: SwitchableContentViewController<PhotoContentType> {

    lazy var photoVC = PhotoViewController()

    unowned let delegate: ProfilePhotoViewControllerDelegate

    init(with delegate: ProfilePhotoViewControllerDelegate) {
        self.delegate = delegate
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initializeViews() {
        super.initializeViews()

        self.view.set(backgroundColor: .background2)
        self.photoVC.view.set(backgroundColor: .background2)

        self.photoVC.onDidComplete = { [unowned self] result in
            switch result {
            case .success:
                self.delegate.profilePhotoViewControllerDidFinish(self)
            case .failure(let error):
                print(error)
            }
        }
    }

    override func getInitialContent() -> PhotoContentType {
        return .photo(self.photoVC)
    }

    override func getTitle() -> Localized {
        return LocalizedString(id: "",
                               arguments: [],
                               default: "Update Face Scan")
    }

    override func getDescription() -> Localized {
        return LocalizedString(id: "",
                               arguments: [],
                               default: "Tap begin to update your profile with another face scan. Don't forget to 😁")
    }
}
