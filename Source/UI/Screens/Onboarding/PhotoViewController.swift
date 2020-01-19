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

    override func initializeViews() {
        super.initializeViews()

        self.view.set(backgroundColor: .background1)

        self.view.addSubview(self.avatarView)
        self.avatarView.isHidden = true
        self.addChild(viewController: self.cameraVC)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.cameraVC.view.expandToSuperviewSize()

        self.avatarView.frame = self.cameraVC.view.frame
        self.avatarView.roundCorners()
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

        current.saveEventually()
            .observe { (result) in
                switch result {
                case .success(_):
                    self.complete(with: .success(()))
                case .failure(let error):
                    self.complete(with: .failure(error))
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
