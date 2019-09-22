//
//  testCoreMLViewController.swift
//  ProvINS
//
//  Created by Sarvad shetty on 9/21/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import UIKit
import AVFoundation
import Vision


var name = ""

class testCoreMLViewController: UIViewController {
    
    
    @IBOutlet weak var videoPreview: UIView!
    
    //mark: - variables
    var videoDataOutput: AVCaptureVideoDataOutput!
    var videoDataOutputQueue: DispatchQueue!
    var previewLayer:AVCaptureVideoPreviewLayer!
    var captureDevice : AVCaptureDevice!
    let session = AVCaptureSession()
    var delegate:hi!
    
    var videoCapture: VideoCapture!
    var currentBuffer: CVPixelBuffer?
    
    let coreMLModel = MobileNetV2_SSDLite()
    
    lazy var visionModel: VNCoreMLModel = {
        do {
            return try VNCoreMLModel(for: coreMLModel.model)
        } catch {
            fatalError("Failed to create VNCoreMLModel: \(error)")
        }
    }()
    
    lazy var visionRequest: VNCoreMLRequest = {
        let request = VNCoreMLRequest(model: visionModel, completionHandler: {
            [weak self] request, error in
            self?.processObservations(for: request, error: error)
        })
        
        // NOTE: If you use another crop/scale option, you must also change
        // how the BoundingBoxView objects get scaled when they are drawn.
        // Currently they assume the full input image is used.
        request.imageCropAndScaleOption = .scaleFill
        return request
    }()
    
    let maxBoundingBoxViews = 10
    var boundingBoxViews = [BoundingBoxView]()
    var colors: [String: UIColor] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBoundingBoxViews()
        setUpCamera()
//        setupAVCapture()
    }
    
    func setUpBoundingBoxViews() {
        for _ in 0..<maxBoundingBoxViews {
            boundingBoxViews.append(BoundingBoxView())
        }
        
        // The label names are stored inside the MLModel's metadata.
        guard let userDefined = coreMLModel.model.modelDescription.metadata[MLModelMetadataKey.creatorDefinedKey] as? [String: String],
            let allLabels = userDefined["classes"] else {
                fatalError("Missing metadata")
        }
        
        let labels = allLabels.components(separatedBy: ",")
        
        // Assign random colors to the classes.
        for label in labels {
            colors[label] = UIColor(red: CGFloat.random(in: 0...1),
                                    green: CGFloat.random(in: 0...1),
                                    blue: CGFloat.random(in: 0...1),
                                    alpha: 1)
        }
    }
    
    func setUpCamera() {
        videoCapture = VideoCapture()
        videoCapture.delegate = self
        
        videoCapture.setUp(sessionPreset: .hd1280x720) { success in
            if success {
                // Add the video preview into the UI.
                if let previewLayer = self.videoCapture.previewLayer {
                    self.videoPreview.layer.addSublayer(previewLayer)
                    self.resizePreviewLayer()
                }
                
                // Add the bounding box layers to the UI, on top of the video preview.
                for box in self.boundingBoxViews {
                    box.addToLayer(self.videoPreview.layer)
                }
                
                // Once everything is set up, we can start capturing live video.
                self.videoCapture.start()
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        resizePreviewLayer()
    }
    
    func resizePreviewLayer() {
        videoCapture.previewLayer?.frame = videoPreview.bounds
    }
    
    func predict(sampleBuffer: CMSampleBuffer) {
        if currentBuffer == nil, let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
            currentBuffer = pixelBuffer
            
            // Get additional info from the camera.
            var options: [VNImageOption : Any] = [:]
            if let cameraIntrinsicMatrix = CMGetAttachment(sampleBuffer, key: kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, attachmentModeOut: nil) {
                options[.cameraIntrinsics] = cameraIntrinsicMatrix
            }
            
            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: options)
            do {
                try handler.perform([self.visionRequest])
            } catch {
                print("Failed to perform Vision request: \(error)")
            }
            
            currentBuffer = nil
        }
    }
    
    func processObservations(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            if let results = request.results as? [VNRecognizedObjectObservation] {
                self.show(predictions: results)
            } else {
                self.show(predictions: [])
            }
        }
    }
    
    func show(predictions: [VNRecognizedObjectObservation]) {
        for i in 0..<boundingBoxViews.count {
            if i < predictions.count {
                let prediction = predictions[i]
                let width = view.bounds.width
                let height = width * 16 / 9
                let offsetY = (view.bounds.height - height) / 2
                let scale = CGAffineTransform.identity.scaledBy(x: width, y: height)
                let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -height - offsetY)
                let rect = prediction.boundingBox.applying(scale).applying(transform)
                
                // The labels array is a list of VNClassificationObservation objects,
                // with the highest scoring class first in the list.
                let bestClass = prediction.labels[0].identifier
                let confidence = prediction.labels[0].confidence
                
                let array = ["laptop","cell phone","mouse","tv","keyboard","oven","microwave","toaster","refrigerator"]
                
                if array.contains(bestClass) {
                    // Show the bounding box.
                    let label = String(format: "%@ %.1f", bestClass, confidence * 100)
                    let color = colors[bestClass] ?? UIColor.red
                    print("detected: \(bestClass)")
                    boundingBoxViews[i].show(frame: rect, label: label, color: color)
                    
                    //cancel and go back to view
                    videoCapture.stop()
                    name = bestClass
                    deviceType = bestClass
                    delegate.dataName(name: bestClass)
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                boundingBoxViews[i].hide()
            }
        }
    }
//
//    func setupAVCapture(){
//        session.sessionPreset = AVCaptureSession.Preset.vga640x480
//        guard let device = AVCaptureDevice
//            .default(AVCaptureDevice.DeviceType.builtInWideAngleCamera,
//                     for: .video,
//                     position: AVCaptureDevice.Position.back) else{
//                        return
//        }
//        captureDevice = device
//                beginSession()
//    }
//
//    func beginSession(){
//        var deviceInput: AVCaptureDeviceInput!
//        do {
//            deviceInput = try AVCaptureDeviceInput(device: captureDevice)
//            guard deviceInput != nil else {
//                print("error: cant get deviceInput")
//                return
//            }
//
//            if self.session.canAddInput(deviceInput){
//                self.session.addInput(deviceInput)
//            }
//
//            videoDataOutput = AVCaptureVideoDataOutput()
//            videoDataOutput.alwaysDiscardsLateVideoFrames=true
//            videoDataOutputQueue = DispatchQueue(label: "VideoDataOutputQueue")
//            videoDataOutput.setSampleBufferDelegate(self, queue:self.videoDataOutputQueue)
//
//            if session.canAddOutput(self.videoDataOutput){
//                session.addOutput(self.videoDataOutput)
//            }
//
//            videoDataOutput.connection(with: AVMediaType.video)?.isEnabled = true
//
//            self.previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
//            self.previewLayer.videoGravity = AVLayerVideoGravity.resizeAspect
//
//            let rootLayer: CALayer = self.view.layer
//            rootLayer.masksToBounds = true
//            self.previewLayer.frame = rootLayer.bounds
//            rootLayer.addSublayer(self.previewLayer)
//            session.startRunning()
//        } catch let error as NSError {
//            deviceInput = nil
//            print("error: \(error.localizedDescription)")
//        }
//    }


}

extension testCoreMLViewController: VideoCaptureDelegate {
    func videoCapture(_ capture: VideoCapture, didCaptureVideoFrame sampleBuffer: CMSampleBuffer) {
        predict(sampleBuffer: sampleBuffer)
    }
}
