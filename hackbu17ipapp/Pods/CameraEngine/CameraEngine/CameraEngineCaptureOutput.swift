//
//  CameraEngineCaptureOutput.swift
//  CameraEngine2
//
//  Created by Remi Robert on 24/12/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit
import AVFoundation

public typealias blockCompletionCapturePhoto = (_ image: UIImage?, _ error: Error?) -> (Void)
public typealias blockCompletionCapturePhotoBuffer = ((_ sampleBuffer: CMSampleBuffer?, _ error: Error?) -> Void)
public typealias blockCompletionCaptureVideo = (_ url: URL?, _ error: NSError?) -> (Void)
public typealias blockCompletionOutputBuffer = (_ sampleBuffer: CMSampleBuffer) -> (Void)
public typealias blockCompletionProgressRecording = (_ duration: Float64) -> (Void)

extension AVCaptureVideoOrientation {
    static func orientationFromUIDeviceOrientation(_ orientation: UIDeviceOrientation) -> AVCaptureVideoOrientation {
//        switch orientation {
//        case .portrait: return .portrait
//        case .landscapeLeft: return .landscapeRight
//        case .landscapeRight: return .landscapeLeft
//        case .portraitUpsideDown: return .portraitUpsideDown
//        default: return .portrait
//        }
        return .portrait
    }
}

class CameraEngineCaptureOutput: NSObject {
    
    let stillCameraOutput = AVCaptureStillImageOutput()
    let movieFileOutput = AVCaptureMovieFileOutput()
    var captureVideoOutput = AVCaptureVideoDataOutput()
    var captureAudioOutput = AVCaptureAudioDataOutput()
    var blockCompletionVideo: blockCompletionCaptureVideo?
    
    let videoEncoder = CameraEngineVideoEncoder()
    
    var isRecording = false
    var blockCompletionBuffer: blockCompletionOutputBuffer?
    var blockCompletionProgress: blockCompletionProgressRecording?
	
	func capturePhotoBuffer(_ blockCompletion: @escaping blockCompletionCapturePhotoBuffer) {
		guard let connectionVideo  = self.stillCameraOutput.connection(withMediaType: AVMediaTypeVideo) else {
			blockCompletion(nil, nil)
			return
		}
		connectionVideo.videoOrientation = AVCaptureVideoOrientation.orientationFromUIDeviceOrientation(UIDevice.current.orientation)
		self.stillCameraOutput.captureStillImageAsynchronously(from: connectionVideo, completionHandler: blockCompletion)
	}
	
    func capturePhoto(_ blockCompletion: @escaping blockCompletionCapturePhoto) {
        guard let connectionVideo  = self.stillCameraOutput.connection(withMediaType: AVMediaTypeVideo) else {
            blockCompletion(nil, nil)
            return
        }
        connectionVideo.videoOrientation = AVCaptureVideoOrientation.orientationFromUIDeviceOrientation(UIDevice.current.orientation)
        
        self.stillCameraOutput.captureStillImageAsynchronously(from: connectionVideo) { (sampleBuffer: CMSampleBuffer?, err: Error?) -> Void in
            if let err = err {
                blockCompletion(nil, err)
            }
            else {
                if let sampleBuffer = sampleBuffer, let dataImage = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer) {
                    let image = UIImage(data: dataImage)
                    blockCompletion(image, nil)
                }
                else {
                    blockCompletion(nil, nil)
                }
            }
        }
    }
    
    func setPressetVideoEncoder(_ videoEncoderPresset: CameraEngineVideoEncoderEncoderSettings) {
        self.videoEncoder.presetSettingEncoder = videoEncoderPresset.configuration()
    }
    
    func startRecordVideo(_ blockCompletion: @escaping blockCompletionCaptureVideo, url: URL) {
        if self.isRecording == false {
            self.videoEncoder.startWriting(url)
            self.isRecording = true
        }
        else {
            self.isRecording = false
            self.stopRecordVideo()
        }
        self.blockCompletionVideo = blockCompletion
    }
    
    func stopRecordVideo() {
        self.isRecording = false
        self.videoEncoder.stopWriting(self.blockCompletionVideo)
    }
    
    func configureCaptureOutput(_ session: AVCaptureSession, sessionQueue: DispatchQueue) {
        if session.canAddOutput(self.captureVideoOutput) {
            session.addOutput(self.captureVideoOutput)
            self.captureVideoOutput.setSampleBufferDelegate(self, queue: sessionQueue)
        }
        if session.canAddOutput(self.captureAudioOutput) {
            session.addOutput(self.captureAudioOutput)
            self.captureAudioOutput.setSampleBufferDelegate(self, queue: sessionQueue)
        }
        if session.canAddOutput(self.stillCameraOutput) {
            session.addOutput(self.stillCameraOutput)
        }
        
    }
}

extension CameraEngineCaptureOutput: AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate {
    
    private func progressCurrentBuffer(_ sampleBuffer: CMSampleBuffer) {
        if let block = self.blockCompletionProgress, self.isRecording {
            block(self.videoEncoder.progressCurrentBuffer(sampleBuffer))
        }
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        self.progressCurrentBuffer(sampleBuffer)
        if let block = self.blockCompletionBuffer {
            block(sampleBuffer)
        }
        if CMSampleBufferDataIsReady(sampleBuffer) == false || self.isRecording == false {
            return
        }
        if captureOutput == self.captureVideoOutput {
            self.videoEncoder.appendBuffer(sampleBuffer, isVideo: true)
        }
        else if captureOutput == self.captureAudioOutput {
            self.videoEncoder.appendBuffer(sampleBuffer, isVideo: false)
        }
    }
}

extension CameraEngineCaptureOutput: AVCaptureFileOutputRecordingDelegate {
    /*!
     @method captureOutput:didFinishRecordingToOutputFileAtURL:fromConnections:error:
     @abstract
     Informs the delegate when all pending data has been written to an output file.
     
     @param captureOutput
     The capture file output that has finished writing the file.
     @param fileURL
     The file URL of the file that has been written.
     @param connections
     An array of AVCaptureConnection objects attached to the file output that provided the data that was written to the file.
     @param error
     An error describing what caused the file to stop recording, or nil if there was no error.
     
     @discussion
     This method is called when the file output has finished writing all data to a file whose recording was stopped, either because startRecordingToOutputFileURL:recordingDelegate: or stopRecording were called, or because an error, described by the error parameter, occurred (if no error occurred, the error parameter will be nil). This method will always be called for each recording request, even if no data is successfully written to the file.
     
     Clients should not assume that this method will be called on a specific thread.
     
     Delegates are required to implement this method.
     */
    @available(iOS 4.0, *)
    public func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        // nil
    }

    
    func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [AnyObject]!) {
        print("start recording ...")
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [AnyObject]!, error: Error!) {
        print("end recording video ... \(outputFileURL)")
        print("error : \(error)")
        if let blockCompletionVideo = self.blockCompletionVideo {
            blockCompletionVideo(outputFileURL, error as NSError?)
        }
    }
}
