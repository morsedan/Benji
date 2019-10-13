//
//  LoginProfilePhotoViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 8/12/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse
import CameraManager

protocol LoginProfilePhotoViewControllerDelegate: class {
    func loginProfilePhotoViewControllerDidUpdatePhoto(_ controller: LoginProfilePhotoViewController)
}

class LoginProfilePhotoViewController: ViewController {

    private let cameraManager = CameraManager()
    private let cameraView = View()
    private let avatarView = AvatarView()
    private let cameraButton = CameraButton()
    private let label = RegularSemiBoldLabel()

    unowned let delegate: LoginProfilePhotoViewControllerDelegate

    init(with delegate: LoginProfilePhotoViewControllerDelegate) {
        self.delegate = delegate
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initializeViews() {
        super.initializeViews()

        self.view.set(backgroundColor: .background1)
        self.view.addSubview(self.cameraView)
        self.cameraView.layer.borderColor = Color.purple.color.cgColor
        self.cameraView.layer.borderWidth = 4

        self.view.addSubview(self.avatarView)
        self.avatarView.isHidden = true

        self.view.addSubview(self.label)
        self.label.set(text: "Take a picture. 😀",
                       color: .white,
                       alignment: .center,
                       stringCasing: .unchanged)

        self.view.addSubview(self.cameraButton)

        self.cameraManager.cameraDevice = .front
        self.cameraManager.addPreviewLayerToView(self.cameraView)
        self.cameraButton.onTap { [unowned self] (tap) in
            self.captureImage()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let width = self.view.width * 0.8
        self.cameraView.size = CGSize(width: width, height: width)
        self.cameraView.centerY = self.view.centerY * 0.8
        self.cameraView.centerOnX()
        self.cameraView.roundCorners()

        self.avatarView.frame = self.cameraView.frame
        self.avatarView.roundCorners()

        self.cameraButton.size = CGSize(width: 60, height: 60)
        self.cameraButton.bottom = self.view.height - self.view.safeAreaInsets.bottom - 40
        self.cameraButton.centerOnX()

        self.label.setSize(withWidth: self.view.width * 0.8)
        self.label.top = self.cameraView.bottom + 20
        self.label.centerOnX()
    }

    func captureImage() {
        self.cameraManager.capturePictureWithCompletion({ result in
            switch result {
                case .failure:
                    break
                case .success(let content):
                    guard let image = content.asImage else { return }
                    self.avatarView.isHidden = false
                    self.avatarView.set(avatar: image)
                    self.saveProfilePicture(image: image)
            }
        })
    }

    func saveProfilePicture(image: UIImage) {
        guard let imageData = image.pngData(), let current = PFUser.current() else { return }

        // NOTE: Remember, we're in points not pixels. Max image size will
        // depend on image pixel density. It's okay for now.
        let maxAllowedDimension: CGFloat = 50.0
        let longSide = max(image.size.width, image.size.height)

        var scaledImage: UIImage
        if longSide > maxAllowedDimension {
            let scaleFactor: CGFloat = maxAllowedDimension / longSide
            scaledImage = image.scaled(by: scaleFactor)
        } else {
            scaledImage = image
        }

        if let scaledData = scaledImage.pngData() {
            let scaledImageFile = PFFileObject(name:"small_image.png", data: scaledData)
            current.smallProfileImageFile = scaledImageFile
        }

        let largeImageFile = PFFileObject(name:"image.png", data: imageData)
        current.largeProfileImageFile = largeImageFile

        current.saveObject()
            .ignoreUserInteractionEventsUntilDone()
            .observe { (result) in
                switch result {
                case .success(_):
                    self.delegate.loginProfilePhotoViewControllerDidUpdatePhoto(self)
                case .failure(let error):
                    print(error)
                }
        }
    }
}
