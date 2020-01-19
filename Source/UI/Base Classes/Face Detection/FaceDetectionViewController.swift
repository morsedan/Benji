//
//  CameraManager.swift
//  Benji
//
//  Created by Benji Dodgson on 10/13/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import AVFoundation

class FaceDetectionViewController: ViewController {

    var captureSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                          for: .video,
                                                          position: .front) else { return }
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            self.captureSession = AVCaptureSession()
            self.captureSession?.addInput(input)
            self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            self.view.layer.addSublayer(self.previewLayer!)
        } catch {
            print(error)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.captureSession?.startRunning()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.captureSession?.stopRunning()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.previewLayer?.frame = self.view.layer.bounds
    }

    func capturePhoto(completion: @escaping (UIImage) -> Void) {
//        self.captureSession?.capture({ (image, settings) in
//            guard let rotatedImage = image.fixedOrientation() else { return }
//            completion(rotatedImage)
//        }) { (error) in
//            print(error)
//        }
    }
}
