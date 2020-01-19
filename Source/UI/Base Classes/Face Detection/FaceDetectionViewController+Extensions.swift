//
//  FaceDetectionViewController+Extensions.swift
//  Benji
//
//  Created by Benji Dodgson on 1/18/20.
//  Copyright © 2020 Benjamin Dodgson. All rights reserved.
//

import Foundation
import AVFoundation
import Vision

// MARK: - Video Processing methods

extension FaceDetectionViewController {

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
        self.view.layer.insertSublayer(self.previewLayer, at: 0)
    }
}

extension FaceDetectionViewController: AVCaptureVideoDataOutputSampleBufferDelegate {

    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {

        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        let detectFaceRequest = VNDetectFaceLandmarksRequest(completionHandler: self.detectedFace)

        do {
            try self.sequenceHandler.perform(
                [detectFaceRequest],
                on: imageBuffer,
                orientation: .leftMirrored)
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension FaceDetectionViewController {
    
    func convert(rect: CGRect) -> CGRect {
        let origin = self.previewLayer.layerPointConverted(fromCaptureDevicePoint: rect.origin)
        let size = self.previewLayer.layerPointConverted(fromCaptureDevicePoint: rect.size.cgPoint)
        return CGRect(origin: origin, size: size.cgSize)
    }

    func landmark(point: CGPoint, to rect: CGRect) -> CGPoint {
        let absolute = point.absolutePoint(in: rect)
        let converted = previewLayer.layerPointConverted(fromCaptureDevicePoint: absolute)
        return converted
    }

    func landmark(points: [CGPoint]?, to rect: CGRect) -> [CGPoint]? {
        guard let points = points else {
            return nil
        }

        return points.compactMap { self.landmark(point: $0, to: rect) }
    }

    func updateFaceView(for result: VNFaceObservation) {
        defer {
            runMain {
                self.faceView.setNeedsDisplay()
            }
        }

        let box = result.boundingBox
        self.faceView.boundingBox = self.convert(rect: box)

        guard let landmarks = result.landmarks else { return }

        if let leftEye = self.landmark(
            points: landmarks.leftEye?.normalizedPoints,
            to: result.boundingBox) {
            self.faceView.leftEye = leftEye
        }

        if let rightEye = self.landmark(
            points: landmarks.rightEye?.normalizedPoints,
            to: result.boundingBox) {
            self.faceView.rightEye = rightEye
        }

        if let leftEyebrow = self.landmark(
            points: landmarks.leftEyebrow?.normalizedPoints,
            to: result.boundingBox) {
            self.faceView.leftEyebrow = leftEyebrow
        }

        if let rightEyebrow = self.landmark(
            points: landmarks.rightEyebrow?.normalizedPoints,
            to: result.boundingBox) {
            self.faceView.rightEyebrow = rightEyebrow
        }

        if let nose = self.landmark(
            points: landmarks.nose?.normalizedPoints,
            to: result.boundingBox) {
            self.faceView.nose = nose
        }

        if let outerLips = self.landmark(
            points: landmarks.outerLips?.normalizedPoints,
            to: result.boundingBox) {
            self.faceView.outerLips = outerLips
        }

        if let innerLips = self.landmark(
            points: landmarks.innerLips?.normalizedPoints,
            to: result.boundingBox) {
            self.faceView.innerLips = innerLips
        }

        if let faceContour = self.landmark(
            points: landmarks.faceContour?.normalizedPoints,
            to: result.boundingBox) {
            self.faceView.faceContour = faceContour
        }
    }

    func updateLaserView(for result: VNFaceObservation) {

        self.laserView.clear()
        let yaw = result.yaw ?? 0.0

        if yaw == 0.0 {
            return
        }

        var origins: [CGPoint] = []

        if let point = result.landmarks?.leftPupil?.normalizedPoints.first {
            let origin = self.landmark(point: point, to: result.boundingBox)
            origins.append(origin)
        }

        if let point = result.landmarks?.rightPupil?.normalizedPoints.first {
            let origin = self.landmark(point: point, to: result.boundingBox)
            origins.append(origin)
        }

        let avgY = origins.map { $0.y }.reduce(0.0, +) / CGFloat(origins.count)

        let focusY = (avgY < self.midY) ? 0.75 * self.maxY : 0.25 * self.maxY

        let focusX = (yaw.doubleValue < 0.0) ? -100.0 : self.maxX + 100.0

        let focus = CGPoint(x: focusX, y: focusY)

        for origin in origins {
            let laser = Laser(origin: origin, focus: focus)
            self.laserView.add(laser: laser)
        }

        runMain {
            self.laserView.setNeedsDisplay()
        }
    }

    func detectedFace(request: VNRequest, error: Error?) {
        guard let results = request.results as? [VNFaceObservation], let result = results.first else {
            self.faceView.clear()
            return
        }

        if self.faceViewHidden {
            self.updateLaserView(for: result)
        } else {
            self.updateFaceView(for: result)
        }
    }
}
