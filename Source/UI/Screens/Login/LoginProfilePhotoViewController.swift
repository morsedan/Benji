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
        self.view.addSubview(self.label)
        self.label.set(text: "Take a picture. 😀",
                       color: .white,
                       alignment: .center,
                       stringCasing: .unchanged)

        self.view.addSubview(self.cameraButton)

        self.cameraVC.currentCameraPosition = .rear
        self.cameraButton.onTap { [unowned self] (tap) in
            self.captureImage()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let width = self.view.width * 0.8
        self.cameraVC.view.size = CGSize(width: width, height: width)
        self.cameraVC.view.centerY = self.view.centerY * 0.8
        self.cameraVC.view.centerOnX()
        self.cameraVC.view.roundCorners()

        self.cameraButton.size = CGSize(width: 60, height: 60)
        self.cameraButton.bottom = self.view.height - self.view.safeAreaInsets.bottom - 40
        self.cameraButton.centerOnX()

        self.label.setSize(withWidth: self.view.width * 0.8)
        self.label.top = self.cameraVC.view.bottom + 20
        self.label.centerOnX()
    }

    //    func pixelate(image: UIImage) {
    //        guard let currentCGImage = image.cgImage else { return }
    //        let currentCIImage = CIImage(cgImage: currentCGImage)
    //
    //        let filter = CIFilter(name: "CIPixellate")
    //        filter?.setValue(currentCIImage, forKey: kCIInputImageKey)
    //        filter?.setValue(50, forKey: kCIInputScaleKey)
    //        guard let outputImage = filter?.outputImage else { return }
    //
    //        let context = CIContext()
    //
    //        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
    //            let processedImage = UIImage(cgImage: cgimg)
    //            self.avatarView.set(avatar: processedImage)
    //        }
    //    }

    func captureImage() {
        self.cameraVC.captureImage {(image, error) in
            guard let strongImage = image else {
                print(error ?? "Image capture error")
                return
            }

            self.saveProfilePicture(image: strongImage)
        }
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

        let largeImageFile = PFFileObject(name:"image.png", data: imageData)

        if let scaledData = scaledImage.pngData() {
            let scaledImageFile = PFFileObject(name:"scaled_image.png", data: scaledData)
            current["scaledProfilePicture"] = scaledImageFile
        }

        current["profilePicuter"] = largeImageFile

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
