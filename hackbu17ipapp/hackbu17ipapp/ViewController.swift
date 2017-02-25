//
//  ViewController.swift
//  hackbu17ipapp
//
//  Created by Charles DiGiovanna on 2/25/17.
//  Copyright © 2017 Charles DiGiovanna. All rights reserved.
//
//
//import UIKit
//
//class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    @IBOutlet var pickedImage: UIImageView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//
//    @IBAction func tapCameraButton(_ sender: Any) {
//        // cam
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
//            let imagePicker = UIImagePickerController()
//            imagePicker.delegate = self
//            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
//            imagePicker.allowsEditing = false
//            present(imagePicker, animated: true, completion: nil)
//            print("iffing")
//        }else{
//            print("elsing")
//        }
//        
////        // lib
////        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
////            let imagePicker = UIImagePickerController()
////            imagePicker.delegate = self
////            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
////            imagePicker.allowsEditing = true
////            present(imagePicker, animated: true, completion: nil)
////            print("iffing2")
////        }else{
////            print("elsign2")
////        }
////        
////        // save
////        let imageData = UIImageJPEGRepresentation(pickedImage.image!, 0.6)
////        let compressJPEGImage = UIImage(data: imageData!)
////        UIImageWriteToSavedPhotosAlbum(compressJPEGImage!, nil, nil, nil)
//    }
//    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]) {
//        pickedImage.image = image
//        dismiss(animated: true, completion: nil)
//    }
//}
//
/////////////////////////////////////////////////////////////////////////
//import UIKit
//import AVFoundation
//
//class ViewController: UIViewController {
//    
//    @IBOutlet weak var previewView: UIView!
//    @IBOutlet weak var capturedImage: UIImageView!
//    
//    var captureSession: AVCaptureSession?
//    var stillImageOutput: AVCapturePhotoOutput?
//    var previewLayer: AVCaptureVideoPreviewLayer?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        captureSession = AVCaptureSession()
//        captureSession!.sessionPreset = AVCaptureSessionPresetPhoto
//        
//        let backCamera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
//        
//        var error: NSError?
//        var input: AVCaptureDeviceInput!
//        do {
//            input = try AVCaptureDeviceInput(device: backCamera)
//        } catch let error1 as NSError {
//            error = error1
//            input = nil
//        }
//        
//        if error == nil && captureSession!.canAddInput(input) {
//            captureSession!.addInput(input)
//            
//            stillImageOutput = AVCapturePhotoOutput()
////            stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
//            if captureSession!.canAddOutput(stillImageOutput) {
//                captureSession!.addOutput(stillImageOutput)
//                
//                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//                previewLayer!.videoGravity = AVLayerVideoGravityResizeAspect
//                previewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
//                previewView.layer.addSublayer(previewLayer!)
//                
//                captureSession!.startRunning()
//            }
//        }
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        previewLayer!.frame = previewView.bounds
//    }
//    
//    @IBAction func didPressTakePhoto(_ sender: Any) {
//        if let videoConnection = stillImageOutput!.connection(withMediaType: AVMediaTypeVideo) {
//            videoConnection.videoOrientation = AVCaptureVideoOrientation.portrait
////            stillImageOutput?.capturePhoto(with: videoConnection, delegate: self)
////            
////            stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {(sampleBuffer, error) in
////                if (sampleBuffer != nil) {
////                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
////                    let dataProvider = CGDataProviderCreateWithCFData(imageData)
////                    let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, CGColorRenderingIntent.RenderingIntentDefault)
////                    
////                    let image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Right)
////                    self.capturedImage.image = image
////                }
////            })
//        }
//    }
//    
////    @IBAction func didPressTakeAnother(sender: AnyObject) {
////        captureSession!.startRunning()
////    }
//}

//////////////////////////////////////////////////////////////////////////////

//
//  ViewController.swift
//  CameraExample
//
//  Created by Geppy Parziale on 2/15/16.
//  Copyright © 2016 iNVASIVECODE, Inc. All rights reserved.
//
///////////////////////////////////////////////////////////////////
//import UIKit
//import AVFoundation
//
//class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        print("vdl")
//        setupCameraSession()
//        print("vdl2")
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        print("vda")
//        view.layer.addSublayer(previewLayer)
//        print("vda1.5")
//        cameraSession.startRunning()
//        print("vda2")
//    }
//    
//    lazy var cameraSession: AVCaptureSession = {
//        print("Cs")
//        let s = AVCaptureSession()
//        s.sessionPreset = AVCaptureSessionPresetLow
//        print("Cs2")
//        return s
//    }()
//    
//    lazy var previewLayer: AVCaptureVideoPreviewLayer = {
//        print("prl")
//        let preview =  AVCaptureVideoPreviewLayer(session: self.cameraSession)
//        preview?.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
//        preview?.position = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
//        preview?.videoGravity = AVLayerVideoGravityResize
//        print("prl2")
//        return preview!
//    }()
//    
//    func setupCameraSession() {
//        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) as AVCaptureDevice
//        
//        do {
//            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
//            
//            cameraSession.beginConfiguration()
//            
//            if (cameraSession.canAddInput(deviceInput) == true) {
//                cameraSession.addInput(deviceInput)
//            }
//            
//            let dataOutput = AVCaptureVideoDataOutput()
//            dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange as UInt32)]
//            dataOutput.alwaysDiscardsLateVideoFrames = true
//            
//            if (cameraSession.canAddOutput(dataOutput) == true) {
//                cameraSession.addOutput(dataOutput)
//            }
//            
//            cameraSession.commitConfiguration()
//            
//            let queue = DispatchQueue(label: "com.invasivecode.videoQueue")
//            dataOutput.setSampleBufferDelegate(self, queue: queue)
//            
//        }
//        catch let error as NSError {
//            print("AHHH error")
//            NSLog("\(error), \(error.localizedDescription)")
//        }
//    }
//    
//    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
//        // Here you collect each frame and process it
//    }
//    
//    func captureOutput(_ captureOutput: AVCaptureOutput!, didDrop sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
//        // Here you can count how many frames are dopped
//    }
//    
//}














