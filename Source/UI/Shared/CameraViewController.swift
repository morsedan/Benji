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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.previewView.session = self.photoSession
        self.photoSession.cameraPosition = .front
        self.photoSession.cameraDetection = .faces
        self.photoSession.resolution = CGSize(width: 300, height: 300)
        self.photoSession.zoom = 1.5

        self.view.addSubview(self.previewView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.photoSession.start()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.photoSession.stop()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.previewView.frame = self.view.bounds
        self.previewView.previewLayer?.frame = self.previewView.bounds
    }

    func capturePhoto(completion: @escaping (UIImage) -> Void) {
        self.photoSession.capture({ (image, settings) in
            completion(image)
        }) { (error) in
            print(error)
        }
    }
}
