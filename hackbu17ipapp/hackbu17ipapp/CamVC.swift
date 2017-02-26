//
//  CamVC.swift
//  hackbu17ipapp
//
//  Created by Charles DiGiovanna on 2/25/17.
//  Copyright © 2017 Charles DiGiovanna. All rights reserved.
//

import UIKit
import CameraEngine
import AWSS3

enum ModeCapture {
    case Photo
    case Video
}

class CamVC: UIViewController {
    private var cameraEngine = CameraEngine()
    private var mode: ModeCapture = .Video
    
    @IBOutlet var recordingBubble: UIView! {
        didSet {
            recordingBubble.layer.cornerRadius = recordingBubble.frame.height / 2
        }
    }
    @IBOutlet var recLabel: UILabel!
    @IBOutlet var groupsButton: UIButton!
    @IBOutlet var chleft: UIView!
    @IBOutlet var chright: UIView!
    @IBOutlet var chbottom: UIView!
    @IBOutlet var chtop: UIView!
    var chs: [UIView] {
        let tmp: [UIView] = [chleft, chright, chbottom, chtop]
        return tmp
    }
    var animating = false
    
    @IBOutlet var slider: UISlider!{
        didSet{
            slider.transform = CGAffineTransform.init(rotationAngle: CGFloat(-M_PI_2))
        }
    }
    
    @IBOutlet weak var buttonTrigger: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cameraEngine.startSession()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.cameraEngine.rotationCamera = true
//        if USER == nil {
//            performSegue(withIdentifier: "CamVCToNewUser", sender: nil)
//        }
        // COMMENTING THIS OUT UNTIL WE GOT THE SERVER
        if !animating {
            animateRecordingBubble()
            animating = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let layer = self.cameraEngine.previewLayer else {
            return
        }
        layer.frame = self.view.bounds
        self.view.layer.insertSublayer(layer, at: 0)
    }
    
    @IBAction func sliding(_ sender: Any) {
        cameraEngine.cameraZoomFactor = CGFloat(slider.value)
    }
    
    func animateRecordingBubble() {
        UIView.animate(withDuration: 1, animations: {
            self.recordingBubble.alpha = 0.0
        }, completion: { _ in
            UIView.animate(withDuration: 1, animations: {
                self.recordingBubble.alpha = 1.0
            }, completion: { _ in
                self.animateRecordingBubble()
            })
        })
    }

    @IBAction func takePhoto(_ sender: AnyObject) {
        switch self.mode {
        case .Photo: // NOT USED ANYMORE 17822
            self.cameraEngine.capturePhoto { (image , error) -> (Void) in
                if let image = image {
                    CameraEngineFileManager.savePhoto(image, blockCompletion: { (success, error) -> (Void) in
                        if success {
                            let alertController =  UIAlertController(title: "Success, image saved!", message: nil, preferredStyle: .alert)
                            alertController.view.tintColor = UIColor.red
                            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                        }
                    })
                }
            }
        case .Video:
            if !self.cameraEngine.isRecording {
                if let url = CameraEngineFileManager.temporaryPath("video.mp4") {
                    
                    self.recordingBubble.isHidden = false
                    self.buttonTrigger.setImage(#imageLiteral(resourceName: "povgun"), for: .normal)
                    for ch in self.chs {
                        ch.isHidden = false
                    }
                    slider.isHidden = false
                    groupsButton.isEnabled = false
                    recLabel.isHidden = false
                    
                    self.cameraEngine.startRecordingVideo(url, blockCompletion: { (url: URL?, error: NSError?) -> (Void) in
                        if let url = url {
                            DispatchQueue.main.async {
                                
                                
                                self.recordingBubble.isHidden = true
                                self.buttonTrigger.setImage(#imageLiteral(resourceName: "record"), for: .normal)
                                for ch in self.chs {
                                    ch.isHidden = true
                                }
                                self.slider.isHidden = true
                                self.slider.value = 1.0
                                self.cameraEngine.cameraZoomFactor = CGFloat(self.slider.value)
                                self.groupsButton.isEnabled = true
                                self.recLabel.isHidden = true
                                CameraEngineFileManager.saveVideo(url, blockCompletion: { (success: Bool, error: Error?) -> (Void) in
                                    if success {
                                        let alertController =  UIAlertController(title: "Got em!", message: nil, preferredStyle: .alert)
                                        alertController.view.tintColor = UIColor.red
                                        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                        self.present(alertController, animated: true, completion: nil)
                                        self.upload(url: url)
                                        print(url.absoluteString)
                                        print(url)
//                                        self.download(url:url)
                                    }
                                })
                            }
                        }
                    })
                }
            }
            else {
                self.cameraEngine.stopRecordingVideo()
            }
        }
    }
    
    @IBAction func groupsTapped(_ sender: Any) {
        performSegue(withIdentifier: "CamVCToGroups", sender: nil)
    }
    
    func upload(url: URL){
        let fileURL = url
        let dateTime = Date().iso8601
        let fileKey = dateTime + ".mp4"
        let  transferUtility = AWSS3TransferUtility.default()
        transferUtility.uploadFile(fileURL,
                                   bucket: "hackbu-videos",
                                   key: fileKey, //needs to be replaced with name
            contentType: "video/mp4",
            expression: nil,
            completionHandler: nil).continueWith {
                (task) -> AnyObject! in if let error = task.error {
                    print("Error: \(error.localizedDescription)")
                }
                
                if let _ = task.result {
                    // Do something with uploadTask.
                }
                
//                self.performSegue(withIdentifier: "CamVCToTarget", sender: fileKey)
                
                return nil;
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GroupsToGroupUsers" {
            let vc = segue.destination as! TargetTableViewController
            
            vc.fileKey = sender as? String
        }
    }
}
