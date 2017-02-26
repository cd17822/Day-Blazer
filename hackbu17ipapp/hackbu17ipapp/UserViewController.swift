//
//  UserViewController.swift
//  hackbu17ipapp
//
//  Created by Charles DiGiovanna on 2/25/17.
//  Copyright © 2017 Charles DiGiovanna. All rights reserved.
//

import UIKit
import CameraEngine
import AWSS3

class UserViewController: UIViewController {
    var user: User?
    var group: Group?
    @IBOutlet var iconbg: UIView! {
        didSet {
            iconbg.layer.cornerRadius = iconbg.frame.height / 2
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func download(fileKey: String){
        if let url = CameraEngineFileManager.temporaryPath("video.mp4") {
            let downloadingFileURL = url
            let transferManager = AWSS3TransferManager.default()
            let downloadRequest = AWSS3TransferManagerDownloadRequest()
            downloadRequest?.bucket = "hackbu-videos"
            downloadRequest?.key = "video.mp4" //needs to be replaced with name
            downloadRequest?.downloadingFileURL = downloadingFileURL
            transferManager.download(downloadRequest!).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask<AnyObject>) -> Any? in
                
                if let error = task.error as? NSError {
                    if error.domain == AWSS3TransferManagerErrorDomain, let code = AWSS3TransferManagerErrorType(rawValue: error.code) {
                        switch code {
                        case .cancelled, .paused:
                            break
                        default:
                            print("Error1 downloading: \(downloadRequest?.key) Error: \(error)")
                        }
                    } else {
                        print("Error2 downloading: \(downloadRequest?.key) Error: \(error)")
                    }
                    return nil
                }
                print("Download complete for: \(downloadRequest?.key)")
                //let downloadOutput = task.result
                return nil
            })
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
