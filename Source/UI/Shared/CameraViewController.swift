//
//  CameraManager.swift
//  Benji
//
//  Created by Benji Dodgson on 10/13/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import CameraKit_iOS

class CameraViewController: ViewController {

    lazy var photoSession = CKFPhotoSession()
    lazy var previewView = CKFPreviewView(frame: self.view.bounds)

    override func initializeViews() {
        super.initializeViews()

        self.previewView.session = self.photoSession
        self.photoSession.cameraPosition = .front
        self.photoSession.cameraDetection = .faces
        self.photoSession.zoom = 1.5
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.photoSession.start()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.photoSession.stop()
    }

    func capturePhoto(completion: @escaping (UIImage) -> Void) {
        self.photoSession.capture({ (image, settings) in
            completion(image)
        }) { (error) in
            print(error)
        }
    }
}
