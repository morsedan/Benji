//
//  LoginProfilePhotoViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 8/12/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse

protocol LoginProfilePhotoViewControllerDelegate: class {
    func loginProfilePhotoViewControllerDidUpdatePhoto(_ controller: LoginProfilePhotoViewController)
}

class LoginProfilePhotoViewController: ViewController {

    private let cameraVC = CameraViewController()
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
        self.addChild(viewController: self.cameraVC)
        self.cameraVC.view.layer.borderColor = Color.purple.color.cgColor
        self.cameraVC.view.layer.borderWidth = 4

        self.view.addSubview(self.avatarView)
        self.avatarView.isHidden = true

        self.view.addSubview(self.label)
        self.label.set(text: "Take a picture. 😀",
                       color: .white,
                       alignment: .center,
                       stringCasing: .unchanged)

        self.view.addSubview(self.cameraButton)

        self.cameraButton.onTap { [unowned self] (tap) in
            self.cameraVC.capturePhoto { [unowned self] (image) in
                self.update(image: image)
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let width = self.view.width * 0.8
        self.cameraVC.view.size = CGSize(width: width, height: width)
        self.cameraVC.view.centerY = self.view.centerY * 0.8
        self.cameraVC.view.centerOnX()
        self.cameraVC.view.roundCorners()

        self.avatarView.frame = self.cameraVC.view.frame
        self.avatarView.roundCorners()

        self.cameraButton.size = CGSize(width: 60, height: 60)
        self.cameraButton.bottom = self.view.height - self.view.safeAreaInsets.bottom - 40
        self.cameraButton.centerOnX()

        self.label.setSize(withWidth: self.view.width * 0.8)
        self.label.top = self.cameraVC.view.bottom + 20
        self.label.centerOnX()
    }

    func update(image: UIImage) {
        self.avatarView.isHidden = false
        self.avatarView.set(avatar: image)
        self.saveProfilePicture(image: image)
    }

    func saveProfilePicture(image: UIImage) {
        guard let blackWhiteImage = self.createBlackAndWhite(from: image),
            let imageData = blackWhiteImage.pngData(),
            let current = User.current() else { return }

        // NOTE: Remember, we're in points not pixels. Max image size will
        // depend on image pixel density. It's okay for now.
        let maxAllowedDimension: CGFloat = 50.0
        let longSide = max(image.size.width, image.size.height)

        var scaledImage: UIImage
        if longSide > maxAllowedDimension {
            let scaleFactor: CGFloat = maxAllowedDimension / longSide
            scaledImage = blackWhiteImage.scaled(by: scaleFactor)
        } else {
            scaledImage = blackWhiteImage
        }

        if let scaledData = scaledImage.pngData() {
            let scaledImageFile = PFFileObject(name:"small_image.png", data: scaledData)
            current.smallImage = scaledImageFile
        }

        let largeImageFile = PFFileObject(name:"image.png", data: imageData)
        current.largeImage = largeImageFile

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

    func createBlackAndWhite(from image: UIImage) -> UIImage? {
        guard let currentCGImage = image.cgImage else { return nil }
        let currentCIImage = CIImage(cgImage: currentCGImage)

        let filter = CIFilter(name: "CIColorMonochrome")
        filter?.setValue(currentCIImage, forKey: "inputImage")

        // set a gray value for the tint color
        filter?.setValue(CIColor(red: 0.7, green: 0.7, blue: 0.7), forKey: "inputColor")

        filter?.setValue(1.0, forKey: "inputIntensity")
        guard let outputImage = filter?.outputImage else { return nil }

        let context = CIContext()

        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgimg)
        }

        return nil
    }
}
