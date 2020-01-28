//
//  VideoCatpureVC.swift
//  CaptchaSDK
//
//  Created by Prasanth Podalakur on 10/04/19.
//  Copyright © 2019 Prasanth Podalakur. All rights reserved.
//

import UIKit
import AVFoundation
class VideoCatpureVC: UIViewController,AVCaptureFileOutputRecordingDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var captureSession = AVCaptureSession()
    var sessionOutput = AVCaptureStillImageOutput()
    var movieOutput = AVCaptureMovieFileOutput()
    var previewLayer = AVCaptureVideoPreviewLayer()
    var timer = Timer()
    
    @IBOutlet var cameraView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.cameraView = self.view
        
        let session = AVCaptureDevice.DiscoverySession.init(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        let devices = session.devices
        guard let audioDevice = AVCaptureDevice.default(for: .audio) else { return }
        for device in devices
        {
            if device.position == AVCaptureDevice.Position.back
            {
                do{
                    let input = try AVCaptureDeviceInput(device: device )
                    let audioDeviceInput = try AVCaptureDeviceInput(device: audioDevice)
                    if captureSession.canAddInput(input){
                        
                        captureSession.addInput(input)
                        captureSession.addInput(audioDeviceInput)
                        sessionOutput.outputSettings = [AVVideoCodecKey : AVVideoCodecType.jpeg]
                        
                        if captureSession.canAddOutput(sessionOutput)
                        {
                            captureSession.addOutput(sessionOutput)
                            
                            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                            previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                            cameraView.layer.addSublayer(previewLayer)
                            previewLayer.position = CGPoint(x: self.cameraView.frame.width / 2, y: self.cameraView.frame.height / 2)
                            previewLayer.bounds = cameraView.frame
                            
                        }
                        captureSession.addOutput(movieOutput)
                        captureSession.startRunning()
                        self.handleCaptureSession()
                        
                    }
                    
                }
                catch{
                    
                    print("Error")
                }
                
            }
        }
        
    }
    
    func handleCaptureSession()
    {
        print("-----------Starting-----------")
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MMM-dd HH:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        let fileName = dateString + "output.mov"
        let fileUrl = paths[0].appendingPathComponent(fileName)
        try? FileManager.default.removeItem(at: fileUrl)
        self.movieOutput.startRecording(to: fileUrl, recordingDelegate: self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute:
            {
                print("-----------Stopping-----------")
                self.movieOutput.stopRecording()
        })
    }
    
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print("FINISHED \(error )")
        // save video to camera roll
        if error == nil {
            print("---------------FilePath--------------\(outputFileURL.path)")
            UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, nil, nil, nil)
            self.handleCaptureSession()
        }
    }
}


