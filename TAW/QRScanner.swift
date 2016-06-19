//
//  QRScanner.swift
//  TAW
//
//  Created by Graphics on 2016/6/8.
//  Copyright © 2016年 Dark. All rights reserved.
//

import AVFoundation
import UIKit

class QRScanner: NSObject, AVCaptureMetadataOutputObjectsDelegate
{
    // 給 QR Code 使用
    var captureSession: AVCaptureSession!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var qrCodeFrameView: UIView!
    
    var messageLabel: UILabel!
    var QRToolbar: UIToolbar!
    
    var GetToken: String = ""
    
    init(view: UIView, inputLabel: UILabel, QRBar: UIToolbar)
    {
        super.init()
        
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        messageLabel = inputLabel
        QRToolbar = QRBar
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            
            // Detect all the supported bar code
            captureMetadataOutput.metadataObjectTypes = supportedBarCodes
            
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
    }
    
    func Start(view: UIView)
    {
     
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Move the message label to the top view
        view.bringSubviewToFront(QRToolbar)
        view.bringSubviewToFront(messageLabel)
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        
        // 找到 QR code 的時候
        if let qrCodeFrameView = qrCodeFrameView
        {
            qrCodeFrameView.layer.borderColor = UIColor.greenColor().CGColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubviewToFront(qrCodeFrameView)
        }

        
        // Start video capture
        captureSession?.startRunning()
        
        messageLabel.hidden = false
        QRToolbar.hidden = false
        
    }
    
    func Stop(view: UIView)
    {
        // Stop video capture
        messageLabel.text = ""
        captureSession?.stopRunning()
        qrCodeFrameView?.frame = CGRectZero
        videoPreviewLayer.removeFromSuperlayer()
        
        messageLabel.hidden = true
        QRToolbar.hidden = true
    }
    
    
    // Added to support different barcodes
    let supportedBarCodes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeAztecCode]
    
    @objc func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            
            // no barcode/QR code is detected
            qrCodeFrameView?.frame = CGRectZero
            messageLabel.text = ""
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        // Here we use filter method to check if the type of metadataObj is supported
        // Instead of hardcoding the AVMetadataObjectTypeQRCode, we check if the type
        // can be found in the array of supported bar codes.
        if supportedBarCodes.contains(metadataObj.type) {
            //        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                if(metadataObj.stringValue.containsString("Token: "))
                {
                    GetToken = metadataObj.stringValue.stringByReplacingOccurrencesOfString("Token: ",withString: "")
                }
                messageLabel.text = metadataObj.stringValue
            }
        }
    }

    func CheckToken(token: String) -> Bool
    {
        if GetToken == token
        {
            return true
        }
        return false
    }
}
