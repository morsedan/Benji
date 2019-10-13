//
//  CameraView.swift
//  Benji
//
//  Created by Benji Dodgson on 10/12/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import AVFoundation

enum CameraControllerError: Swift.Error {

    case captureSessionAlreadyRunning
    case captureSessionIsMissing
    case inputsAreInvalid
    case invalidOperation
    case noCamerasAvailable
    case unknown
}

enum CameraPosition {
    case front
    case rear
}

class CameraViewController: ViewController {

    var captureSession: AVCaptureSession?

    var currentCameraPosition: CameraPosition?

    var frontCamera: AVCaptureDevice?
    var frontCameraInput: AVCaptureDeviceInput?

    var photoOutput: AVCapturePhotoOutput?

    var rearCamera: AVCaptureDevice?
    var rearCameraInput: AVCaptureDeviceInput?

    var previewLayer: AVCaptureVideoPreviewLayer?

    var photoCaptureCompletionBlock: ((UIImage?, Error?) -> Void)?

    override func initializeViews() {
        super.initializeViews()

        self.captureSession = AVCaptureSession()

        self.prepare()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.displayPreview()
    }

    func prepare() {
        DispatchQueue(label: "prepare").async {
            self.configureCaptureDevices()
            self.configureDeviceInputs()
            self.configurePhotoOutput()
        }
    }

    func displayPreview() {

        guard let captureSession = self.captureSession,
            captureSession.isRunning,
            self.previewLayer == nil else {
                self.previewLayer?.frame = view.frame
                return
        }

        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer?.connection?.videoOrientation = .portrait
        self.previewLayer?.frame = self.view.bounds
        self.view.layer.insertSublayer(self.previewLayer!, at: 0)
    }

    func switchCameras() throws {
        guard let currentCameraPosition = currentCameraPosition, let captureSession = self.captureSession, captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }

        captureSession.beginConfiguration()

        switch currentCameraPosition {
        case .front:
            try switchToRearCamera()

        case .rear:
            try switchToFrontCamera()
        }

        captureSession.commitConfiguration()
    }

    func switchToFrontCamera() throws {

         guard let captureSession = self.captureSession, captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }

        guard let rearCameraInput = self.rearCameraInput, captureSession.inputs.contains(rearCameraInput),
            let frontCamera = self.frontCamera else { throw CameraControllerError.invalidOperation }

        self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)

        captureSession.removeInput(rearCameraInput)

        if captureSession.canAddInput(self.frontCameraInput!) {
            captureSession.addInput(self.frontCameraInput!)

            self.currentCameraPosition = .front
        }

        else {
            throw CameraControllerError.invalidOperation
        }
    }

    func configurePhotoOutput() {
        guard let captureSession = self.captureSession else { return }

        self.photoOutput = AVCapturePhotoOutput()
        self.photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)

        if let output = self.photoOutput, captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        captureSession.startRunning()
    }

    func configureDeviceInputs() {
        guard let captureSession = self.captureSession else { return }

        if let rearCamera = self.rearCamera {
            do {
                self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
                if let input = self.rearCameraInput, captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                }

                self.currentCameraPosition = .rear
            }
            catch {
                print("Error")
            }
        } else if let frontCamera = self.frontCamera {

            do {
                self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
                if let input = self.frontCameraInput, captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                }

                self.currentCameraPosition = .front
            }
            catch {
                print("Error")
            }
        } else {
            print("Error")
        }
    }

    func configureCaptureDevices() {

        let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .unspecified)

        let cameras = session.devices.compactMap { $0 }
        guard !cameras.isEmpty else {  return }

        for camera in cameras {
            if camera.position == .front {
                self.frontCamera = camera
            }

            if camera.position == .back {
                self.rearCamera = camera

                do {
                    try camera.lockForConfiguration()
                    camera.focusMode = .continuousAutoFocus
                    camera.unlockForConfiguration()
                }
                catch {
                    print("Error with rear camera")
                }
            }
        }
    }

    func switchToRearCamera() throws {

        guard let captureSession = self.captureSession, captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }

        guard let frontCameraInput = self.frontCameraInput, captureSession.inputs.contains(frontCameraInput),
            let rearCamera = self.rearCamera else { throw CameraControllerError.invalidOperation }

        self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)

        captureSession.removeInput(frontCameraInput)

        if captureSession.canAddInput(self.rearCameraInput!) {
            captureSession.addInput(self.rearCameraInput!)

            self.currentCameraPosition = .rear
        }

        else { throw CameraControllerError.invalidOperation }
    }

    func captureImage(completion: @escaping (UIImage?, Error?) -> Void) {
        
        guard let captureSession = captureSession, captureSession.isRunning else { completion(nil, CameraControllerError.captureSessionIsMissing); return }

        let settings = AVCapturePhotoSettings()

        self.photoOutput?.capturePhoto(with: settings, delegate: self)
        self.photoCaptureCompletionBlock = completion
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {

    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {

        if let error = error {
            self.photoCaptureCompletionBlock?(nil, error)
        } else if let data = photo.fileDataRepresentation(), let image = UIImage(data: data) {
            self.photoCaptureCompletionBlock?(image, nil)
        } else {
            self.photoCaptureCompletionBlock?(nil, CameraControllerError.unknown)
        }
    }
}
