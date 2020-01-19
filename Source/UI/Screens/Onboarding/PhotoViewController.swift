//
//  LoginProfilePhotoViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 8/12/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse
import TMROFutures

class PhotoViewController: ViewController, Sizeable, Completable {
    typealias ResultType = Void

    var onDidComplete: ((Result<Void, Error>) -> Void)?

    private lazy var cameraVC: FaceDetectionViewController = {
        let vc: FaceDetectionViewController = UIStoryboard(name: "FaceDetection", bundle: nil).instantiateViewController(withIdentifier: "FaceDetection") as! FaceDetectionViewController

        return vc
    }()

    private let avatarView = AvatarView()
    private let button = LoadingButton()

    override func initializeViews() {
        super.initializeViews()

        self.view.set(backgroundColor: .background1)

        self.view.addSubview(self.avatarView)
        self.addChild(viewController: self.cameraVC)

        self.avatarView.layer.borderColor = Color.purple.color.cgColor
        self.avatarView.layer.borderWidth = 4

        self.avatarView.isHidden = true
        self.view.addSubview(self.button)

        self.cameraVC.didCapturePhoto = { [unowned self] image in
             self.update(image: image)
        }

        self.button.set(style: .normal(color: .blue, text: "Begin"))
        self.button.didSelect = { [unowned self] in
            if self.avatarView.isHidden {
                self.cameraVC.begin()
            } else {
                self.button.isLoading = true
                self.cameraVC.capturePhoto()
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.cameraVC.view.expandToSuperviewSize()

        let height = self.view.height * 0.6
        let width = height * 0.7
        self.avatarView.size = CGSize(width: width, height: height)
        self.avatarView.top = 30
        self.avatarView.centerOnX()
        self.avatarView.roundCorners()

        self.button.size = CGSize(width: 200, height: 40)
        self.button.bottom = self.view.height - 30
        self.button.centerOnX()
    }

    func update(image: UIImage) {
        guard let fixed = image.fixedOrientation(), let pixImage = self.pixelate(image: fixed) else { return }
        self.avatarView.isHidden.toggle()
        self.cameraVC.view.isHidden.toggle()

        self.avatarView.set(avatar: pixImage)
        self.saveProfilePicture(image: pixImage)
    }

    func saveProfilePicture(image: UIImage) {
        guard let imageData = image.pngData(), let current = User.current() else { return }

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
            current.smallImage = scaledImageFile
        }

        let largeImageFile = PFFileObject(name:"image.png", data: imageData)
        current.largeImage = largeImageFile

        current.saveEventually()
            .observe { (result) in
                switch result {
                case .success(_):
                    self.complete(with: .success(()))
                case .failure(let error):
                    self.complete(with: .failure(error))
                }
                self.button.isLoading = false
        }
    }

    func pixelate(image: UIImage) -> UIImage? {
        guard let currentCGImage = image.cgImage else { return nil}
        let currentCIImage = CIImage(cgImage: currentCGImage)

        let filter = CIFilter(name: "CIPixellate")
        filter?.setValue(currentCIImage, forKey: kCIInputImageKey)
        filter?.setValue(50, forKey: kCIInputScaleKey)
        guard let outputImage = filter?.outputImage else { return nil }

        let context = CIContext()

        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            return processedImage
        }

        return nil
    }
}
