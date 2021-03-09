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
    var ean             : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scannedTicket = DataToCraft(string: "")
        
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
            let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
            
            let input : AVCaptureDeviceInput? = try AVCaptureDeviceInput(device: captureDevice)
            
            // If our input is not nil then add it to the session, otherwise we're kind of done!
            if input != nil {
                self.session.addInput(input)
            }
            
            let output = AVCaptureMetadataOutput()
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            self.session.addOutput(output)
            output.metadataObjectTypes = output.availableMetadataObjectTypes
            
            
            self.previewLayer = AVCaptureVideoPreviewLayer(session: self.session) as AVCaptureVideoPreviewLayer
            self.previewLayer.frame = self.view.bounds
            self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            self.view.layer.addSublayer(self.previewLayer)
            
            // Start the scanner. You'll have to end it yourself later.
            self.session.startRunning()
        }
        catch {}
    }
    
    
    // This is called when we find a known barcode type with the camera.
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
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
                
                if (metadata as AnyObject).type == barcodeType {
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
            scannedTicket.setText(self.ean!)
            
            if scannedTicket.isMickeyType() {
                // Vibrate
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                // Go back to the previous view
                _ = navigationController?.popViewController(animated: true)
            }
            else {
                let actionIfCancelled : (UIAlertAction)->() = {
                    [unowned self] action in
                    // Purge the scannedTicket var
                    scannedTicket = DataToCraft(string: "")
                    // Relaunch the capture
                    self.session.startRunning()
                }
                
                // Tell the user it is not a valid Ticket
                alertThatItIsNotAValidMickeyCode(self, actionCancel: actionIfCancelled, actionOK: nil)
            }
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
