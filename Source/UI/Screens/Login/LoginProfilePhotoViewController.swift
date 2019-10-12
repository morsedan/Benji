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
    private let doneButton = LoadingButton()

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

        self.view.addSubview(self.doneButton)

        self.doneButton.set(style: .normal(color: .blue, text: "DONE")) {
            self.captureImage()
        }

        self.cameraVC.prepare {(error) in

            if let error = error {
                print(error)
            }

            try? self.cameraVC.displayPreview(on: self.cameraVC.view)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let width = self.view.width * 0.8
        self.cameraVC.view.size = CGSize(width: width, height: width)
        self.cameraVC.view.centerY = self.view.centerY * 0.8
        self.cameraVC.view.centerOnX()
        self.cameraVC.view.roundCorners()
        self.cameraVC.previewLayer?.frame = self.cameraVC.view.frame

        self.doneButton.size = CGSize(width: self.view.width - 28, height: 40)
        self.doneButton.bottom = self.view.height - self.view.safeAreaInsets.bottom - 40
        self.doneButton.centerOnX()
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

        let imageFile = PFFileObject(name:"image.png", data: imageData)
        current["profilePicture"] = imageFile
        self.doneButton.isLoading = true
        current.saveInBackground { (success, error) in
            guard success else { return }
            self.delegate.loginProfilePhotoViewControllerDidUpdatePhoto(self)
            self.doneButton.isLoading = false
        }
    }
}
