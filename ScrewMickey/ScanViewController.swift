//
//  ScanViewController.swift
//  ScrewMickey
//
//  Created by clement rabourdin on 14/01/2016.
//  Copyright © 2016 Syluaq DP Team. All rights reserved.
//

import UIKit
import AVFoundation

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    let session         : AVCaptureSession = AVCaptureSession()
    var previewLayer    : AVCaptureVideoPreviewLayer!
    let highlightView   = UIView()
    var ean             : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startCapture()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Capture
    */
    
    func startCapture() {
        do {
            // Camera
            let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
            
            let input : AVCaptureDeviceInput? = try AVCaptureDeviceInput(device: captureDevice)
            
            // If our input is not nil then add it to the session, otherwise we're kind of done!
            if input != nil {
                self.session.addInput(input)
            }
            
            let output = AVCaptureMetadataOutput()
            output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            self.session.addOutput(output)
            output.metadataObjectTypes = output.availableMetadataObjectTypes
            
            
            self.previewLayer = AVCaptureVideoPreviewLayer(session: self.session) as AVCaptureVideoPreviewLayer
            self.previewLayer.frame = self.view.bounds
            self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            self.view.layer.addSublayer(self.previewLayer)
            
            // Start the scanner. You'll have to end it yourself later.
            self.session.startRunning()
        }
        catch let error as NSError {
            // Handle any errors
            print(error)
        }
    }
    
    
    // This is called when we find a known barcode type with the camera.
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        //var highlightViewRect = CGRectZero
        
        //var barCodeObject : AVMetadataObject!
        
        //var detectionString : String!
        
        let barCodeTypes = [AVMetadataObjectTypeUPCECode,
            AVMetadataObjectTypeCode39Code,
            AVMetadataObjectTypeCode39Mod43Code,
            AVMetadataObjectTypeEAN13Code,
            AVMetadataObjectTypeEAN8Code,
            AVMetadataObjectTypeCode93Code,
            AVMetadataObjectTypeCode128Code,
            AVMetadataObjectTypePDF417Code,
            AVMetadataObjectTypeQRCode,
            AVMetadataObjectTypeAztecCode
        ]
        
        
        // The scanner is capable of capturing multiple 2-dimensional barcodes in one scan.
        for metadata in metadataObjects {
            
            for barcodeType in barCodeTypes {
                
                if metadata.type == barcodeType {
                    //barCodeObject = self.previewLayer.transformedMetadataObjectForMetadataObject(metadata as! AVMetadataMachineReadableCodeObject)
                    
                    //highlightViewRect = barCodeObject.bounds
                    
                    self.ean = (metadata as! AVMetadataMachineReadableCodeObject).stringValue
                    if self.ean != nil {
                        break
                    }
                }
                
            }
        }
        
        if self.ean != nil {
            // Stop session
            self.session.stopRunning()
            scannedTicket.leText = self.ean!
            scannedTicket.leType = .Entier
            
            // Vibrate
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            
            // Go back to the previous view
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    /*
    // MARK: - Navigation
    */
    
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "idFlipSegue" {
            let produitVC = segue.destinationViewController as! ProduitViewController
            
            if self.ean != nil {
                produitVC.produitEAN = self.ean!
                produitVC.delegate = self
            }
        }
    }*/
    
}
