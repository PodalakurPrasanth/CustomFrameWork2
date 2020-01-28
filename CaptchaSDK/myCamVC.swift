//
//  myCamVC.swift
//  CaptchaSDK
//
//  Created by Prasanth Podalakur on 08/04/19.
//  Copyright © 2019 Prasanth Podalakur. All rights reserved.
//

import UIKit
import AVFoundation

 public class myCamVC: UIViewController,AVCaptureMetadataOutputObjectsDelegate,AVCapturePhotoCaptureDelegate {

    @IBOutlet weak var sampleLabel: UILabel!
   
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var imageViewOBJ: UIImageView!
    var isFront : Bool?
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    override open func viewDidLoad() {
        super.viewDidLoad()

        self.imageViewOBJ.isHidden = true
       self.openCamera()
      sampleLabel.text = "Prasanth's SDK"
      
        
    }
    

    @IBAction private func closeButtonTapped(_ sender:UIButton){
        print ("capture btn clicked")
        if sender.tag == 1 {
            sender.tag = 0
            self.imageViewOBJ.isHidden = false
             self.previewView.isHidden = true
            guard let capturePhotoOutput = self.capturePhotoOutput else { return }
            
            let photoSettings = AVCapturePhotoSettings()
            photoSettings.isAutoStillImageStabilizationEnabled = true
            photoSettings.isHighResolutionPhotoEnabled = true
            photoSettings.flashMode = .off
            
            // Call capturePhoto method by passing our photo settings and a delegate implementing AVCapturePhotoCaptureDelegate
            capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
            //        if showImage.image != nil{
            //            self.navigationController?.popViewController(animated: true)
            //        }
        }else{
            sender.tag = 1
//            self.imageViewOBJ.isHidden = true
//            self.previewView.isHidden = false
//            self.dismiss(animated: true, completion: nil)
            let bundle = Bundle(identifier: "com.vsoft.CaptchaSDK")
            let myStoryboard = UIStoryboard(name: "mySDK", bundle: bundle)
            let camVC = myStoryboard.instantiateViewController(withIdentifier: "VideoCatpureVC") as! VideoCatpureVC
            self.navigationController?.pushViewController(camVC, animated: true)
        }
       
      
    }
    
  private  func openCamera(){
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            let noCameraAlert = UIAlertController(title: "Camera Alert", message: "No Camera Found", preferredStyle: .alert)
            let okactoion = UIAlertAction(title: "ok", style: .default, handler: nil)
            noCameraAlert.addAction(okactoion)
            self.present(noCameraAlert, animated: true, completion: nil)
            //fatalError("No video device found")
            return
        }
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous deivce object
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object
            captureSession = AVCaptureSession()
            
            // Set the input devcie on the capture session
            captureSession?.addInput(input)
            
            // Get an instance of ACCapturePhotoOutput class
            capturePhotoOutput = AVCapturePhotoOutput()
            capturePhotoOutput?.isHighResolutionCaptureEnabled = true
            
            // Set the output on the capture session
            captureSession?.addOutput(capturePhotoOutput!)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the input device
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            
            //            videoPreviewLayer?.frame = CGRect(x: 0, y: 0, width: self.previewView.frame.size.width, height: self.previewView.frame.size.height)
            videoPreviewLayer!.frame = self.previewView.layer.bounds
            
            videoPreviewLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
            
            previewView.layer.addSublayer(videoPreviewLayer!)
            print("preview view :\(self.previewView.layer.frame)")
            print(videoPreviewLayer!.frame)
            captureSession?.startRunning()
            
        } catch {
            //If any error occurs, simply print it out
            print(error)
            return
        }
    }
    
    @IBAction func capture(_ sender: Any) {
        
        print ("capture btn clicked")
        guard let capturePhotoOutput = self.capturePhotoOutput else { return }
        
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .off
        
        // Call capturePhoto method by passing our photo settings and a delegate implementing AVCapturePhotoCaptureDelegate
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
        //        if showImage.image != nil{
        //            self.navigationController?.popViewController(animated: true)
        //        }
    }

    
    //MARK: - Custom Methods
   private func compressImage(image: UIImage) -> UIImage {
        let size = image.size
        
        let widthRatio  = 1600  / image.size.width
        let heightRatio = size.height / image.size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        let rect = CGRect(x :0, y :0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.3)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        print("New Image width and height: \(String(describing: newImage?.size.width)) \(newImage?.size.height)")
        return newImage!
    }
    public func photoOutput(_ captureOutput: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?,
                     previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                     resolvedSettings: AVCaptureResolvedPhotoSettings,
                     bracketSettings: AVCaptureBracketedStillImageSettings?,
                     error: Error?) {
        // Make sure we get some photo sample buffer
        guard error == nil,
            let photoSampleBuffer = photoSampleBuffer else {
                print("Error capturing photo: \(String(describing: error))")
                return
        }
        
        // Convert photo same buffer to a jpeg image data by using AVCapturePhotoOutput
        guard let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {
            return
        }
        
        // Initialise an UIImage with our image data
        
        let dataProvider = CGDataProvider(data: imageData as CFData)
        let cgImageRef: CGImage! = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
        let capturedImage = UIImage(cgImage: cgImageRef, scale: 1.0, orientation: UIImage.Orientation.right
        )
        if let image = capturedImage as? UIImage{
            self.imageViewOBJ.image = image
            let compressedImage =  self.compressImage(image: image)
            weak var __weakSelf = self
            print("Compressed Image size: \(compressedImage.size.width) \(compressedImage.size.height)")
            print("compressedImage.scale \(compressedImage.scale)")
            
            
            print("image captured sussessfully")
        }
    }
    
    public func metadataOutput(_ captureOutput: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is contains at least one object.
        if metadataObjects.count == 0 {
            //            qrCodeFrameView?.frame = CGRect.zero
            //            messageLabel.isHidden = true
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            if metadataObj.stringValue != nil {
            }
        }
    }
}


//MARK:- @IBDesignable extension for UIView
@IBDesignable extension UIView {
    @IBInspectable var borderColor:UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor:color)
            }
            else {
                return nil
            }
        }
    }
    
    @IBInspectable var borderWidth:CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius:CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
}
