//
//  CameraManager.swift
//  Benji
//
//  Created by Benji Dodgson on 10/13/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import AVFoundation
import Vision

class FaceDetectionViewController: UIViewController {
    var sequenceHandler = VNSequenceRequestHandler()

    @IBOutlet var faceView: FaceView!
    @IBOutlet var faceLaserLabel: UILabel!

    let session = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer!

    let dataOutputQueue = DispatchQueue(label: "video data queue",
                                        qos: .userInitiated,
                                        attributes: [],
                                        autoreleaseFrequency: .workItem)

    var maxX: CGFloat = 0.0
    var midY: CGFloat = 0.0
    var maxY: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureCaptureSession()

        self.maxX = view.bounds.maxX
        self.midY = view.bounds.midY
        self.maxY = view.bounds.maxY

        self.session.startRunning()
    }

    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
        print("did tap ")
    }

    func configureCaptureSession() {
        // Define the capture device we want to use
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                   for: .video,
                                                   position: .front) else {
                                                    fatalError("No front video camera available")
        }

        // Connect the camera to the capture session input
        do {
            let cameraInput = try AVCaptureDeviceInput(device: camera)
            self.session.addInput(cameraInput)
        } catch {
            fatalError(error.localizedDescription)
        }

        // Create the video data output
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: self.dataOutputQueue)
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]

        // Add the video output to the capture session
        self.session.addOutput(videoOutput)

        let videoConnection = videoOutput.connection(with: .video)
        videoConnection?.videoOrientation = .portrait

        // Configure the preview layer
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
        self.previewLayer.videoGravity = .resizeAspectFill
        self.previewLayer.frame = self.view.bounds
    }
}
