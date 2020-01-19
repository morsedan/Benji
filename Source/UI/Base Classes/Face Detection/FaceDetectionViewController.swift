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

class FaceDetectionViewController: ViewController {

    var sequenceHandler = VNSequenceRequestHandler()

    let faceView = FaceView()
    let laserView = LaserView()
    let faceLaserLabel = RegularBoldLabel()

    let session = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer!

    let dataOutputQueue = DispatchQueue(
        label: "video data queue",
        qos: .userInitiated,
        attributes: [],
        autoreleaseFrequency: .workItem)

    var faceViewHidden = false

    var maxX: CGFloat = 0.0
    var midY: CGFloat = 0.0
    var maxY: CGFloat = 0.0

    override func initializeViews() {
        super.initializeViews()

        self.view.addSubview(self.faceView)
        self.view.addSubview(self.laserView)
        self.view.addSubview(self.faceLaserLabel)

        self.view.onTap { [unowned self] (tap) in
            self.handleTap()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureCaptureSession()

        self.laserView.isHidden = true

        self.maxX = self.view.bounds.maxX
        self.midY = self.view.bounds.midY
        self.maxY = self.view.bounds.maxY

        self.session.startRunning()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.faceView.expandToSuperviewSize()
        self.laserView.expandToSuperviewSize()

        self.faceLaserLabel.setSize(withWidth: 200)
        self.faceLaserLabel.centerOnX()
        self.faceLaserLabel.bottom = self.view.height - 30
    }

    private func handleTap() {
        self.faceView.isHidden.toggle()
        self.laserView.isHidden.toggle()
        self.faceViewHidden = self.faceView.isHidden

        if self.faceViewHidden {
            self.faceLaserLabel.text = "Lasers"
        } else {
            self.faceLaserLabel.text = "Face"
        }
    }
}
