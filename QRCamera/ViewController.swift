//
//  ViewController.swift
//  QRCamera
//
//  Created by Dan Merfeld on 9/5/19.
//  Copyright © 2019 TheoryThree Interactive. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var previewView: UIView!
    
    var captureSession: AVCaptureSession!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // setup camera session
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        
        // use back camera
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video) else { print("NO Back Camera"); return }
      
        do {
            
            let input = try AVCaptureDeviceInput(device: backCamera)
            
            // check to see if we can add camera to video preview session
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
                // you could add output here
                setupPreviewLayer()
            }
            
            
        } catch let error {
            print("Error, unable to init back camera: \(error.localizedDescription)")
        }
        
    }
    
    // setup preview layer of camera
    func setupPreviewLayer() {
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.connection?.videoOrientation = .portrait
        // add video preview layer to preview view
        previewView.layer.addSublayer(videoPreviewLayer)
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.previewView.bounds
            }
        }
    }

}

