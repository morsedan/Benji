//
//  ProfilePhotoViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 2/1/20.
//  Copyright © 2020 Benjamin Dodgson. All rights reserved.
//

import Foundation

protocol ProfilePhotoViewController: class {
    func profilePhotoViewControllerDid()
}

class UserPhotoViewController: ViewController {

    lazy var photoVC = PhotoViewController()

    unowned let delegate: ProfileViewControllerDelegate

    init(with delegate: ProfileViewControllerDelegate) {
        self.delegate = delegate
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initializeViews() {
        super.initializeViews()

    }
}
