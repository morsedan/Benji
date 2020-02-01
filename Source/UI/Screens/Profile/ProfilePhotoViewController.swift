//
//  ProfilePhotoViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 2/1/20.
//  Copyright © 2020 Benjamin Dodgson. All rights reserved.
//

import Foundation

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

        self.photoVC.onDidComplete = { [unowned self] result in
            switch result {
            case .success:
                self.delegate.profilePhotoViewControllerDidFinish(self)
            case .failure(let error):
                print(error)
            }
        }
    }
}
